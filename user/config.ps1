class WorseFetchUser : WorseFetchDefault {
  # [bool]$truncateHeight = $false
  # [bool]$separator = $false
  # [bool]$box = $true
  # [int]$width = $(if ($self.box -ne $true ) { 60 } else { 20 })

  # [array]$errColor = @($fg_red, $italic)
  [array]$titleColor = @($fg_blue)
  [bool]$box = $false
  # [array]$contentColor = @($fg_white)
  [array]$config = @(
    "fingeros"
    "user"
    "dashes"
    "memory"
    "dashes"
    "blank"
    # "local_ip"
    "theme"
    "dfsdfsdf"
    "fdgdfgd"
  )
  [hashtable]fingeros () {
    return @{
      title   = "OS"
      content = "finger, I laid a finger"
    }
  }
  # [array]$config = @(
  #   "user"
  #   "dashes"
  #   "memory"
  #   "dashes"
  #   "blank"
  #   "dashes"
  #   "computer"
  #   "gpu"
  #   "cpu"
  #   "uptime"
  #   "kernel"
  #   "troll"
  #   "resolution"
  #   "terminal"
  #   # "local_ip"
  #   "theme"
  #   "dfsdfsdf"
  #   "fdgdfgd"
  # )
  # [hashtable]troll () {
  #   return @{
  #     title   = "troll"
  #     content = "trollface"
  #   }
  # }
}