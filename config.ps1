. .\codes.ps1
class WorseFetchBase {}
class WorseFetchDefault : WorseFetchBase {
  [bool]$truncateHeight = $false
  [bool]$separator = $false
  [bool]$box = $true
  [CimSession]$cimSession = $(New-CimSession)
  [Version]$buildVersion = "$([System.Environment]::OSVersion.Version)"
  [ValidateSet("text", "bar", "textbar", "bartext")][string]$memorystyle = "text"
  [int]$width = $(if ($this.box) { 60 } else { 40 })

  [array]$errColor = @($fg_red, $italic)
  [array]$titleColor = @($fg_blue)
  [array]$contentColor = @($fg_white)
  [hashtable]blank() {
    return @{
      title   = ""
      content = "" * $this.width
    }
  }
  [hashtable]dashes() {
    return @{
      title   = ""
      content = "═" * $this.width
      connect = $true
    }
  }
  [hashtable] user() {
    return @{
      title                  = $([System.Environment]::UserName)
      content                = $env:COMPUTERNAME
      override_separator     = "@"
      override_color_content = @($this.titleColor)
    }
  }

  [hashtable] local_ip() {
    $indexDefault = Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Sort-Object -Property RouteMetric | Select-Object -First 1 | Select-Object -ExpandProperty ifIndex
    $localIp = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $indexDefault | Select-Object -ExpandProperty IPAddress
    return @{
      title   = "Local IP"
      content = $localIp
    }
  }

  [hashtable] memory() {
    $m = Get-CimInstance -ClassName Win32_OperatingSystem -Property TotalVisibleMemorySize, FreePhysicalMemory -CimSession $this.cimSession
    $total = $m.TotalVisibleMemorySize / 1mb
    $used = ($m.TotalVisibleMemorySize - $m.FreePhysicalMemory) / 1mb
    $usage = [math]::floor(($used / $total * 100))
    return @{
      title   = "Memory"
      content = $this.get_level_info($usage, "$($used.ToString("#.##")) GiB / $($total.ToString("#.##")) GiB")
    }
  }


  # ===== COMPUTER =====
  [hashtable] computer() {
    $compsys = Get-CimInstance -ClassName Win32_ComputerSystem -Property Manufacturer, Model -CimSession $this.cimSession
    return @{
      title   = "Host"
      content = '{0} {1}' -f $compsys.Manufacturer, $compsys.Model
    }
  }

  [hashtable] kernel() {
    return @{
      title   = "Kernel"
      content = $this.buildVersion
    }
  }

  [hashtable] uptime() {
    return @{
      title   = "Uptime"
      content = $(switch ((Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem -Property LastBootUpTime -CimSession $this.cimSession).LastBootUpTime) {
        ( { $PSItem.Days -eq 1 }) { '1 day' }
        ( { $PSItem.Days -gt 1 }) { "$($PSItem.Days) days" }
        ( { $PSItem.Hours -eq 1 }) { '1 hour' }
        ( { $PSItem.Hours -gt 1 }) { "$($PSItem.Hours) hours" }
        ( { $PSItem.Minutes -eq 1 }) { '1 minute' }
        ( { $PSItem.Minutes -gt 1 }) { "$($PSItem.Minutes) minutes" }
        }) -join ' '
    }
  }

  # ===== RESOLUTION =====
  [hashtable] resolution() {
    $test = Add-Type -AssemblyName System.Windows.Forms -PassThru
    $index = $test.Name.indexOf('Screen')
    $displays = $(foreach ($monitor in $test[$index]::AllScreens) {
        "$($monitor.Bounds.Size.Width)x$($monitor.Bounds.Size.Height)"
      })
    return @{
      title   = "Resolution"
      content = $displays -join ', '
    }
  }

  # ===== TERMINAL =====
  [hashtable] terminal() {
    $is_pscore = $global:PSVersionTable.PSEdition.ToString() -eq 'Core'
    if (-not $is_pscore) {
      $parent = Get-Process -Id (Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = $global:PID" -Property ParentProcessId -CimSession $this.cimSession).ParentProcessId
      for () {
        if ($parent.ProcessName -in 'powershell', 'pwsh', 'winpty-agent', 'cmd', 'zsh', 'bash') {
          $parent = Get-Process -Id (Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = $($parent.ID)" -Property ParentProcessId -CimSession $this.cimSession).ParentProcessId
          continue
        }
        break
      }
    }
    else {
      $parent = (Get-Process -Id $global:PID).Parent
      for () {
        if ($parent.ProcessName -in 'powershell', 'pwsh', 'winpty-agent', 'cmd', 'zsh', 'bash') {
          $parent = (Get-Process -Id $parent.ID).Parent
          continue
        }
        break
      }
    }
    try {
      $terminal = switch ($parent.ProcessName) {
        { $PSItem -in 'explorer', 'conhost' } { 'Windows Console' }
        'Console' { 'Console2/Z' }
        'ConEmuC64' { 'ConEmu' }
        'WindowsTerminal' { 'Windows Terminal' }
        'FluentTerminal.SystemTray' { 'Fluent Terminal' }
        'Code' { 'Visual Studio Code' }
        default { $PSItem }
      }
    }
    catch {
      $terminal = $parent.ProcessName
    }

    return @{
      title   = "Terminal"
      content = $terminal
    }
  }

  [hashtable] theme() {
    $themeinfo = Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name SystemUsesLightTheme, AppsUseLightTheme
    $systheme = if ($themeinfo.SystemUsesLightTheme) { "Light" } else { "Dark" }
    $apptheme = if ($themeinfo.AppsUseLightTheme) { "Light" } else { "Dark" }
    return @{
      title   = "Theme"
      content = "System - $systheme, Apps - $apptheme"
    }
  }

  [hashtable] cpu() {
    return @{
      title   = "CPU"
      content = (Get-CimInstance -ClassName Win32_Processor -Property Name -CimSession $this.cimSession).Name
    }
  }

  [hashtable] gpu() {
    return @{
      title   = "GPU"
      content = (Get-CimInstance -ClassName Win32_VideoController -Property Name -CimSession $this.cimSession).Name
    }
  }

  [string] get_level_info(
    # [string]$barprefix,
    # [string]$style,
    [int]$percentage,
    [string]$text
    # ,
    # [switch]$altstyle
  ) {
    # param (
    #     [string]$barprefix,
    #     [string]$style,
    #     [int]$percentage,
    #     [string]$text,
    #     [switch]$altstyle
    # )

    # switch ($style) {
    #     'bar' { return "$barprefix$(get_percent_bar $percentage)" }
    #     'textbar' { return "$text $(get_percent_bar $percentage)" }
    #     'bartext' { return "$barprefix$(get_percent_bar $percentage) $text" }
    #     default { if ($altstyle) { return "$percentage% ($text)" } else { return "$text ($percentage%)" } }
    # }
    return "$text ($percentage%)"
  }
}

function get_percent_bar {
  param ([Parameter(Mandatory)][ValidateRange(0, 100)][int]$percent)

  $x = [char]9632
  $bar = $null

  $bar += "$e[97m[ $e[0m"
  for ($i = 1; $i -le ($barValue = ([math]::round($percent / 10))); $i++) {
    if ($i -le 6) { $bar += "$e[32m$x$e[0m" }
    elseif ($i -le 8) { $bar += "$e[93m$x$e[0m" }
    else { $bar += "$e[91m$x$e[0m" }
  }
  for ($i = 1; $i -le (10 - $barValue); $i++) { $bar += "$e[97m-$e[0m" }
  $bar += "$e[97m ]$e[0m"

  return $bar
}
