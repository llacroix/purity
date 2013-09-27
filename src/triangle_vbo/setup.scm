(import foreign)
(require-extension extras)
(require-extension lolevel)
(require-extension gl glu glut glm)
(require-extension srfi-19-core)

(define screen_width 800)
(define screen_height 600)

(require "common/opengl")
(require "common/vector")

(define program 0)
(define attribute_coord2d -1)

(define (makeEngine)
  (glut:InitDisplayMode (+ glut:RGBA glut:DOUBLE glut:DEPTH))
  (glut:InitWindowSize screen_width screen_height)
  (glut:CreateWindow "My Rotating Cube")

  (InitResources))

(define (InitResources)
    (define vs (CreateShader gl:VERTEX_SHADER (LoadScript "triangle_vbo/cube.v.glsl")))
    (define fs (CreateShader gl:FRAGMENT_SHADER (LoadScript "triangle_vbo/cube.f.glsl")))

    (set! program (CreateProgram (list vs fs)))
    (set! attribute_coord2d (gl:GetAttribLocation program "coord2d"))

    (print "Program :" program)
    (print "Coord2d :" attribute_coord2d)

    (print "Opengl errors" (gl:GetError))

    #t)

(define (idleFunc)
  (glut:PostRedisplay)
  #t)

(define (reshapeFunc width height)
  ; Setting some globals 
  (set! screen_width width)
  (set! screen_height height)

  ; Defining gl viewport
  (gl:Viewport 0 0 width height)

  (print "Reshape func called"))
