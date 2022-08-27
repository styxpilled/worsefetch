# ANSI ESCAPE CHARACTER
$e = "`e["

# ANSI CONTROL CHARACTERS
$normal = 0
$bold = 1
$faint = 2
$italic = 3
$underline = 4
$slow_blink = 5
$rapid_blink = 6
$reverse = 7
$conceal = 8
$crossed = 9
$primary_font = 10
$secondary_font = @(11, 12, 13, 14, 15, 16, 17, 18, 19)
$fraktur = 20
$bold_off = 21
$bold_off = 22
$italic_off = 23
$underline_off = 24
$blink_off = 25
$reverse_off = 27
$conceal_off = 28
$crossed_off = 29
$set_foreground = 38
$set_background = 48
$framed = 51
$encircled = 52
$overlined = 53
$not_framed = 54
$not_overlined = 55
$ideogram_underline = 60
$ideogram_double_underline = 61
$ideogram_overline = 62
$ideogram_double_overline = 63
$ideogram_stress_marking = 64

# COLOR CODES
$fg_black = 30
$fg_red = 31
$fg_green = 32
$fg_yellow = 33
$fg_blue = 34
$fg_magenta = 35
$fg_cyan = 36
$fg_white = 37
$fg_lblack = 90
$fg_lred = 91
$fg_lgreen = 92
$fg_lyellow = 93
$fg_lblue = 94
$fg_lmagenta = 95
$fg_lcyan = 96
$fg_lwhite = 97
$bg_black = 40
$bg_red = 41
$bg_green = 42
$bg_yellow = 43
$bg_blue = 44
$bg_magenta = 45
$bg_cyan = 46
$bg_white = 47
$bg_lblack = 100
$bg_lred = 101
$bg_lgreen = 102
$bg_lyellow = 103
$bg_lblue = 104
$bg_lmagenta = 105
$bg_lcyan = 106
$bg_lwhite = 107




# $xd = test "balls" @("5B;0", "3")
# $xd = test "balls" @("5C", "5A", "0")
# $xd = moveCursor 15 15 "balls"
# for ($i=0; $i -le 9; $i++) {
#   Write-Output "$i test"
#   # $testing = test "balls" @($i)
#   # $temp = $i - 2
#   # $testing = moveCursor $temp ($i*2) "balls $i"
#   # Write-Host $testing
# }
# Write-Output "${e}30C${e}11A aa"
# get the length of the 1st
# $lineLen = ($img -split "\n" | %{$_.Length} | measure -Maximum).maximum + 1
# $colLen = ($img -split "\n").length
# # Write-Output $lineLen
# # Write-Output $colLen
# # Write-Output "${e}${lineLen}C ${colLen}"
# Write-Output $img
# Write-Output "${e}${lineLen}Cs${e}$($colLen + 1)A"

# for ($i=1; $i -le $colLen; $i++) {
#   # Write-Host $i
#   # $testing = test "balls" @($i)
#   $testing = "${e}${lineLen}C$i"
#   Write-Output $testing
#   # Write-Output "test"
# }

# $out = moveDown 0 0 "balls"
# Write-Host $out
# Write-Output "oops"
# Write-Output "${e}30C${e}2A aa"
# Write-Output "${e}30C aa"
# Write-Host $xd
# Write-Host "balls"