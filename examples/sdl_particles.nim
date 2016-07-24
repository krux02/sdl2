## Bare-bones SDL2 example
import sdl2, sdl2/gfx, random

const
  MaxParticles = 4096
  ParticlesPerFrame = 8
  ParticlesPerButtonEvent = 50

type Particle = object
  x, y: float32
  dx, dy: float32
  age: int32
  r, g, b: uint8
  alive: bool

# var alive : array[NumPartices div 64, uint64]
var particles : array[MaxParticles, Particle]

proc unusedParticle(startIndex: int): tuple[particle: ptr Particle, index: int] =
  for i in startIndex .. particles.high:
    if not particles[i].alive:
      particles[i] = Particle() # clear particle data
      return (particles[i].addr, i)
  return (nil, -1)

proc updateParticles() =
  for i in 0 .. particles.high:
    if particles[i].alive:
      particles[i].x += particles[i].dx
      particles[i].y += particles[i].dy
      particles[i].dx *= 0.95
      particles[i].dy *= 0.95
      particles[i].age += 1
      if particles[i].age > 200:
        echo "disable particle #", i
        particles[i].alive = false

proc renderParticles(render: RendererPtr) =
  var rect: Rect
  rect.w = 10
  rect.h = 10
  for particle in particles:
    if particle.alive:
      rect.x = particle.x.int32 - 5
      rect.y = particle.y.int32 - 5
      render.setDrawColor(particle.r, particle.g, particle.b, 255)
      render.fillRect(rect)

proc main() =
  discard sdl2.init(INIT_EVERYTHING)

  let window = createWindow("SDL Particles", 100, 100, 640,480, SDL_WINDOW_SHOWN)
  defer: window.destroy
  let render = window.createRenderer(-1, Renderer_Software)   
  defer: render.destroy

  var 
    fpsman: FpsManager
    evt : sdl2.Event 
    mouseX, mouseY: int32
    oldMouseX, oldMouseY: int32

  block mainLoop:
    while true:
      while pollEvent(evt):
        if evt.kind == QuitEvent:
          break mainLoop
        if evt.kind == sdl2.KeyDown:
          if evt.key.keysym.scancode ==  SDL_SCANCODE_ESCAPE:
            break mainLoop
        if evt.kind == sdl2.MouseButtonDown or evt.kind == sdl2.MouseButtonUp:
          var 
            particle : ptr Particle
            pindex : int
          for i in 0 ..< ParticlesPerButtonEvent:
            (particle, pindex) = unusedParticle(pindex)
            if particle != nil:
               
              particle.alive = true
              particle.x = evt.button.x.float32
              particle.y = evt.button.y.float32

              particle.r = random(256).uint8 
              particle.g = random(256).uint8
              particle.b = random(256).uint8

              particle.dx = random(6.0).float32 - 3
              particle.dy = random(6.0).float32 - 3
        
      let dt = fpsman.getFramerate / 1000

      oldMouseX = mouseX
      oldMouseY = mouseY
      if (sdl2.getMouseState(mouseX.addr, mouseY.addr) and BUTTON_LMASK) != 0:
        var 
          particle : ptr Particle
          pindex : int
        for i in 0 ..< ParticlesPerFrame:
          (particle, pindex) = unusedParticle(pindex)
          if particle != nil:
            let weight = float32(i / ParticlesPerFrame)

            particle.alive = true
            particle.x = oldMouseX.float32 * (1-weight) + mouseX.float32 * weight
            particle.y = oldMouseY.float32 * (1-weight) + mouseY.float32 * weight

            particle.r = random(256).uint8 
            particle.g = random(256).uint8
            particle.b = random(256).uint8

            particle.dx = random(6.0).float32 - 3
            particle.dy = random(6.0).float32 - 3

      updateParticles()

      render.setDrawColor(0, 0, 0, 255)
      render.clear
      render.setDrawColor(255,255,255,255)
      render.renderParticles

      discard render.stringColor(16,16,"click and drag mouse on screen for effect", high(uint32))
      render.present
      fpsman.delay

main()