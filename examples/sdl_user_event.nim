import sdl2

let MyEventType      = sdl2.registerEvents(1)
let MyOtherEventType = sdl2.registerEvents(1)

var 
  someMessage = "hallo welt!"
  otherMessage = "the world is going to end"
  aThirdMessage = "the world will be reborn"

if MyEventType == high(uint32):
  echo sdl2.getError()
  quit 1

block pushEventsBlock:
  var event : sdl2.Event
  event.kind = cast[EventType](MyEventType)
  event.user.code = 1
  event.user.data1 = someMessage.addr
  pushEvent(event.addr)
  event.user.code = 2
  event.user.data1 = otherMessage.addr
  pushEvent(event.addr)
  event.kind = cast[EventType](MyOtherEventType)
  event.user.code = 3
  event.user.data1 = aThirdMessage.addr
  pushEvent(event.addr)

block pollEventsBlock:
  var event : sdl2.Event
  while sdl2.pollEvent(event):
    if event.kind.uint32 == MyEventType:
      echo "MyEventType:"
      echo "   ", event.user.code, ", ", cast[ptr string](event.user.data1)[]
    elif event.kind.uint32 == MyOtherEventType:
      echo "MyOtherEventType:"
      echo "   ", event.user.code, ", ", cast[ptr string](event.user.data1)[]
