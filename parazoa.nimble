# Package

version       = "0.1.0"
author        = "FIXME"
description   = "FIXME"
license       = "FIXME"
srcDir        = "src"
bin           = @["parazoa"]

task dev, "Run dev version":
  exec "nimble run parazoa"

# Dependencies

requires "nim >= 1.0.4"
requires "pararules >= 0.2.0"
requires "stb_image >= 2.5"

when not defined(release):
  requires "paravim >= 0.8.0"