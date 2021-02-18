# Package

version       = "0.1.0"
author        = "FIXME"
description   = "FIXME"
license       = "FIXME"
srcDir        = "src"
bin           = @["imgui_nim"]
backend       = "cpp"

task dev, "Run dev version":
  exec "nimble run imgui_nim"

# Dependencies

requires "nim >= 1.0.4"
requires "nimgl >= 1.1.8"
requires "pararules >= 0.3.0"

