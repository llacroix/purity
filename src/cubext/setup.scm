(import foreign)
(require-extension extras)
(require-extension lolevel)
(require-extension srfi-19-core)

(require-extension gl glu glut glm)

(define screen_width 800)
(define screen_height 600)

(require "common/opengl")
(require "common/vector")

(define texture_id 0)
(define uniform_mytexture 0)

(define vp (mat4 1))
(define anim (mat4 1))
(define program 0)
(define uniform_mvp 0)
(define attribute_coord3d 0)
(define attribute_v_color 0)

(define vbo_cube_vertices 0)
(define vbo_cube_colors 0)
(define ibo_cube_elements 0)

(define (makeEngine)
  (glut:InitDisplayMode (+ glut:RGBA glut:ALPHA glut:DOUBLE glut:DEPTH))
  (glut:InitWindowSize screen_width screen_height)
  (glut:CreateWindow "My Rotating Cube")

  (InitResources))

  (define cube_vertices (f32vector
            ; front
            -1.0 -1.0  1.0
            1.0 -1.0  1.0
            1.0  1.0  1.0
            -1.0  1.0  1.0
            ; back
            -1.0 -1.0 -1.0
            1.0 -1.0 -1.0
            1.0  1.0 -1.0
            -1.0  1.0 -1.0))

  (define cube_colors (f32vector
             ; front colors
             1.0 0.0 0.0
             0.0 1.0 0.0
             0.0 0.0 1.0
             1.0 1.0 1.0
             ; back colors
             1.0 0.0 0.0
             0.0 1.0 0.0
             0.0 0.0 1.0
             1.0 1.0 1.0))

  (define cube_elements (u16vector
        ; front
        0 1 2
        2 3 0
        ; top
        1 5 6
        6 2 1
        ; back
        7 6 5
        5 4 7
        ; bottom
        4 0 3
        3 7 4
        ; left
        4 5 1
        1 0 4
        ; right
        3 2 6
        6 7 3))

(define (InitResources)
  (gl:Enable gl:BLEND)
  (gl:Enable gl:DEPTH_TEST)

  (print "Cube vertices size " (f32vector-size cube_vertices))
  (set! vbo_cube_vertices (CreateVBO cube_vertices))

  (print "Cube colors size " (f32vector-size cube_colors))
  (set! vbo_cube_colors (CreateVBO cube_colors))

  (set! ibo_cube_elements (CreateVBO16 gl:ELEMENT_ARRAY_BUFFER gl:STATIC_DRAW cube_elements))
  #;(set! ibo_cube_elements (let ((id (u32vector 0)))
     (gl:GenBuffers 1 id)
     (gl:BindBuffer gl:ELEMENT_ARRAY_BUFFER (u32vector-ref id 0))
     (gl:BufferData gl:ELEMENT_ARRAY_BUFFER (* 2 (u16vector-length cube_elements)) (make-locative cube_elements) gl:STATIC_DRAW)
     (u32vector-ref id 0)))

  (define vs (CreateShader gl:VERTEX_SHADER (LoadScript "cubex/cube.v.glsl")))
  (define fs (CreateShader gl:FRAGMENT_SHADER (LoadScript "cubex/cube.f.glsl")))

  (set! program (CreateProgram (list vs fs)))

  (set! attribute_coord3d (gl:GetAttribLocation program "coord3d"))
  (set! attribute_v_color (gl:GetAttribLocation program "v_color"))
  (set! uniform_mvp (gl:GetUniformLocation program "mvp"))

  (print "Vertex shader: " vs)
  (print "Fragment shader: " fs)
  (print "Program :" program)
  (print "Coord3d :" attribute_coord3d)
  (print "AttributeColor :" attribute_v_color)
  (print "Uniform mvp :" uniform_mvp)

  (print "Opengl errors" (gl:GetError))

  #t)

(define (idleFunc)
  ; ??? like in text file
  (define angle (* (glut:Get glut:ELAPSED_TIME) (/ 1 1000) 45))
  (define axis_y (vec3 0 1 0))

  (set! anim (rotate (mat4 1.0) angle axis_y))

  (define view (look-at (vec3 0 2 10)
                        (vec3 0 0 -4)
                        (vec3 0 1 0)))
  (define projection (perspective 45.0 (* 1.0 (/ 800 600)) 0.1 20.0))

  (set! vp (m* (m* projection view) anim))

  (glut:PostRedisplay))

(define (reshapeFunc width height)
  ; Setting some globals 
  (set! screen_width width)
  (set! screen_height height)

  ; Defining gl viewport
  (gl:Viewport 0 0 width height)

  (print "Reshape func called"))
