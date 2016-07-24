## Bare-bones SDL2 example
import sdl2, sdl2/gfx

proc main() =
  discard sdl2.init(INIT_EVERYTHING)

  let window = createWindow("SDL Skeleton", 100, 100, 640,480, SDL_WINDOW_SHOWN)
  defer: window.destroy
  let render = window.createRenderer(-1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)   
  defer: render.destroy

  var 
    fpsman: FpsManager
    evt : sdl2.Event

  block mainLoop:
    echo "main loop"
    while true:
      while pollEvent(evt):
        if evt.kind == QuitEvent:
          break mainLoop
        if evt.kind == sdl2.KeyDown:
          if evt.key.keysym.scancode ==  SDL_SCANCODE_ESCAPE:
            break mainLoop
        
      let dt = fpsman.getFramerate / 1000

      render.setDrawColor 0,0,0,255
      render.clear
      render.present
      fpsman.delay

main()