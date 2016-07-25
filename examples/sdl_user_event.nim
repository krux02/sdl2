import sdl2

let MyEventType      = sdl2.registerEvents(1)

if MyEventType.int32 == -1:
  echo "could not register MyEventType"
  quit 1

let MyOtherEventType = sdl2.registerEvents(1)

if MyOtherEventType.int32 == -1:
  echo "could not register MyOtherEventType"
  quit 1

var 
  someMessage = "hello world!"
  otherMessage = "the world is going to end"
  aThirdMessage = "the world will be reborn"

block pushEventsBlock:
  var event : sdl2.Event
  event.kind = MyEventType
  event.user.code = 1
  event.user.data1 = someMessage.addr
  pushEvent(event.addr)
  event.user.code = 2
  event.user.data1 = otherMessage.addr
  pushEvent(event.addr)
  event.kind = MyOtherEventType
  event.user.code = 3
  event.user.data1 = aThirdMessage.addr
  pushEvent(event.addr)

block pollEventsBlock:
  var event : sdl2.Event
  while sdl2.pollEvent(event):
    if event.kind == MyEventType:
      echo "MyEventType:"
      echo "   ", event.user.code, ", ", cast[ptr string](event.user.data1)[]
    elif event.kind == MyOtherEventType:
      echo "MyOtherEventType:"
      echo "   ", event.user.code, ", ", cast[ptr string](event.user.data1)[]

let FoobarEventType = registerEvents(1000000)

if FoobarEventType.int32 == -1:
  echo "could not create 1000000 event types at once, ... how surprising"
  echo "for those who did not get this yet, this was expected"