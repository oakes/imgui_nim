# Package

version       = "0.1.0"
author        = "FIXME"
description   = "FIXME"
license       = "FIXME"
srcDir        = "src"
bin           = @["parazoa"]
backend       = "cpp"

task dev, "Run dev version":
  exec "nimble run parazoa"

# Dependencies

requires "nim >= 1.0.4"
requires "nimgl >= 1.1.1"
requires "pararules >= 0.2.0"

# Dev Dependencies

requires "paravim >= 0.9.0"
