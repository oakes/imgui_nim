import nimgl/opengl
from nimgl/glfw import GLFWKey
import pararules
import sets
import nimgl/imgui, nimgl/imgui/impl_opengl

when not defined(release):
  import paranim/gl
else:
  type RootGame = object of RootObj

type
  Game* = object of RootGame
    deltaTime*: float
    totalTime*: float
  Id = enum
    Global,
  Attr = enum
    DeltaTime, TotalTime, WindowWidth, WindowHeight,
    PressedKeys, MouseClick, MouseX, MouseY,
  IntSet = HashSet[int]

schema Fact(Id, Attr):
  DeltaTime: float
  TotalTime: float
  WindowWidth: int
  WindowHeight: int
  PressedKeys: IntSet
  MouseClick: int
  MouseX: float
  MouseY: float

let rules =
  ruleset:
    # getters
    rule getWindow(Fact):
      what:
        (Global, WindowWidth, windowWidth)
        (Global, WindowHeight, windowHeight)
    rule getKeys(Fact):
      what:
        (Global, PressedKeys, keys)

var session = initSession(Fact)

for r in rules.fields:
  session.add(r)

proc onKeyPress*(key: int) =
  var (keys) = session.query(rules.getKeys)
  keys.incl(key)
  session.insert(Global, PressedKeys, keys)

proc onKeyRelease*(key: int) =
  var (keys) = session.query(rules.getKeys)
  keys.excl(key)
  session.insert(Global, PressedKeys, keys)

proc onMouseClick*(button: int) =
  session.insert(Global, MouseClick, button)

proc onMouseMove*(xpos: float, ypos: float) =
  session.insert(Global, MouseX, xpos)
  session.insert(Global, MouseY, ypos)

proc onWindowResize*(width: int, height: int) =
  if width == 0 or height == 0:
    return
  session.insert(Global, WindowWidth, width)
  session.insert(Global, WindowHeight, height)

proc init*(game: var Game) =
  # opengl
  doAssert glInit()
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  # imgui
  doAssert igOpenGL3Init()
  igStyleColorsCherry()

  # set initial values
  session.insert(Global, PressedKeys, initHashSet[int]())

var show_demo: bool = true
var somefloat: float32 = 0.0f
var counter: int32 = 0

proc tick*(game: Game) =
  session.insert(Global, DeltaTime, game.deltaTime)
  session.insert(Global, TotalTime, game.totalTime)

  let (windowWidth, windowHeight) = session.query(rules.getWindow)

  if show_demo:
    igShowDemoWindow(show_demo.addr)

  # Simple window
  igBegin("Hello, world!")

  igText("This is some useful text.")
  igCheckbox("Demo Window", show_demo.addr)

  igSliderFloat("float", somefloat.addr, 0.0f, 1.0f)

  if igButton("Button", ImVec2(x: 0, y: 0)):
    counter.inc
  igSameLine()
  igText("counter = %d", counter)

  igText("Application average %.3f ms/frame (%.1f FPS)", 1000.0f / igGetIO().framerate, igGetIO().framerate)
  igEnd()
  # End simple window

  igRender()

  glClearColor(0.45f, 0.55f, 0.60f, 1.00f)
  glClear(GL_COLOR_BUFFER_BIT)
  #glViewport(0, 0, int32(windowWidth), int32(windowHeight))

  igOpenGL3RenderDrawData(igGetDrawData())

