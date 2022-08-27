# using module .\codes.psm1
# using module .\basic.psm1

# [CmdletBinding()]
# Param(
#   [ValidateSet ('saul', 'dwayne', 'literallyme', 'walter', 'lewd', 'astolfo', 'amongus', 'finger', 'tbh', 'morbius', $null)]
#   [string]$logoName = 'saul'
# )
function worsefetch([ValidateSet ('saul', 'dwayne', 'literallyme', 'walter', 'astolfo', 'amongus', 'finger', 'tbh', 'morbius', $null)]
  [string]$logoName = 'saul') {
  . .\codes.ps1
  . .\config.ps1
  # class WorseFetch : WorseFetchDefault {}
  $worsefetch_counter = 0
  # function worsefetch() {
  $name = ". .\logos\$logoName.ps1"
  invoke-Expression $name
  # $testyy = [WorseFetch]::new()
  # $testyy.config
  $lineLen = ($logo -split "\n" | % { $_.Length } | measure -Maximum).maximum + 1
  $colLen = ($logo -split "\n").length
  write-Output $logo
  # write-Output "${e}$($colLen + 1)A"
  $donePrinting = $false
  # . .\config.ps1

  # if ($box) {
  #   $separator = $false
  # }

  function write-Line([string]$text, $connect) {
    $output = "${e}${lineLen}C"
    if ($worsefetch_counter -le $colLen -or !$truncateHeight) {
      if (($worsefetch.separator -or $worsefetch.box) -and $connect -eq !"") {
        $output += "╠"
      }
      elseif (($worsefetch.separator -or $worsefetch.box) -and ($worsefetch_counter -gt 0 -and $worsefetch_counter -le $worsefetch.config.length)) {
        $output += "║"
      }
      if ($worsefetch_counter -eq $colLen -and $truncateHeight) {
        $output += "..."
      }
      else {
        $output += $text
      }
      $output += "${e}${normal}m"
      if ($worsefetch.box -and ($worsefetch_counter -gt 0 -and $worsefetch_counter -le $worsefetch.config.length)) {
        $output += "${e}1000D${e}$($lineLen+$worsefetch.width+1)C"
        if ($connect -eq !"") {
          $output += "╣"
        }
        else {
          $output += "║"
        }
      }
      if ($worsefetch.box -and $worsefetch_counter -eq 0) {
        $output += "╔$("═" * $worsefetch.width)╗"
      }
      elseif ($worsefetch.box -and 
        (
          ($worsefetch_counter -eq $worsefetch.config.length + 1) -or
          ($worsefetch_counter -eq $colLen - 1)
        ) -and !$donePrinting) {
        $output = "${e}${lineLen}C"
        $output += "╚$("═" * $worsefetch.width)╝"
      }
      write-Output $output
      $script:worsefetch_counter++
    }
    elseif ($worsefetch_counter + 1 -eq $colLen -and $truncateHeight -and $text -ne '') {
      write-Output $output
      $script:worsefetch_counter++
    }
    # elseif ($worsefetch_counter -eq $colLen) {
    #   $output += "╚$("═" * $width)╝"
    #   write-Output $output
    #   $script:counter++
    # }
    # write-Output $output
    # $script:counter++
  }
  function color-Text([string]$text, [string[]]$colors) {
    $output = ""
    if ( $colors.length -gt 0) {
      $color = $colors -join ';'
      if ($color -eq "") {
        $color = $fg_yellow
        # Write-Host $colors
      }
      $output += "${e}${color}m"
    }
    $output += $text
    $output += "${e}${normal}m"
    return $output
  }
  . .\user\config.ps1
  # if ($box) {
  #   write-Output "${e}$($colLen + 1)A"
  #   # write-Line "╔$("═" * $width)╗"
  #   # write-Line ""
  # }
  # else {
  #   write-Output "${e}$($colLen + 1)A"
  # }
  try { 
    $worsefetch = [WorseFetch]::new() 
  }
  catch {
    $worsefetch = [WorseFetchUser]::new()
  }
  # $worsefetch = [WorseFetchUser]::new()
  Write-Host $worsefetch.basictest
  # $worsefetch.width = 30
  $methods = (Get-Member -InputObject $worsefetch).name
  # $longest = 0
  # foreach ($item in $worsefetch.config) {
  #   if ($methods -contains $item) {
  #     $info = $worsefetch.$item()
  #     # Write-Host $info
  #   }
  #   else {
  #     $info = @{ title = "" }
  #   }
  #   if ($info.title -ne "") {
  #     if ($info.title.Length + $info.content.Length -gt $longest) {
  #       $longest = $info.title.Length + $info.content.Length + 3
  #     }
  #   }
  # }
  # $worsefetch.width = $longest
  if ($box) {
    write-Line ""
  }

  $output = ""
  write-Line "${e}$($colLen + 1)A"

  # $outputArr = @()
  foreach ($item in $worsefetch.config) {
    if ($methods -contains $item) {
      $info = $worsefetch.$item()
      # Write-Host $info
    }
    else {
      $info = @{ title = color-Text "method '$item' not found" $worsefetch.errColor }
    }
    $output += color-Text $info.title $worsefetch.titleColor
    if ($info.override_separator) {
      $output += $info.override_separator
    }
    elseif ($info.title -and $info.content) {
      $output += ": "
    }
    if ($info.override_color_content) {
      $output += color-Text $info.content $info.override_color_content
    }
    else {
      $output += color-Text $info.content $worsefetch.contentColor
    }
    # write-Line $worsefetch.fg_red
    write-Line $output
    $output = ""
    # $outputArr += $output
  }
  # foreach ($item in $outputArr) {
  # write-Line $item
  # }
  # for ($i = 0; $i -lt $outputArr.Length; $i++) {
  #   write-Line $outputArr[$i]
  # }
  # if ($box) {
  #   if ($worsefetch_counter -eq $colLen) {
  #     # $worsefetch_counter -= 2
  #     # write-Output "${e}$(2)A"
  #     # write-Line "└$("─" * $width)┘"
  #   }
  #   # write-Output "${e}$($worsefetch_counter+1)A"
  #   # $holder = $worsefetch_counter
  #   # $worsefetch_counter = 0
  #   # for ($i=0; $i -le $worsefetch.config.length; $i++) {
  #   #   write-Line "" "" 61
  #   # }
  #   # $worsefetch_counter = $holder
  #   # write-Output "${e}$($worsefetch_counter + 1)B"
  # }
  for ($i = $worsefetch_counter; $i -le $colLen - 1 -and $i -le $Host.UI.RawUI.WindowSize.Height - 4; $i++) {
    write-Line ""
    $donePrinting = $true

  }
  # Write-Host $(Get-Member -InputObject $worsefetch).name
  # $testytest = [WorseFetch]::new()
  # Write-Host $(Get-Member -InputObject $testytest).name
  # Write-Host $worsefetch.box
  # Write-Host $worsefetch.width
  # }
}