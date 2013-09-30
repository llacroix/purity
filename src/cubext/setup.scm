(import foreign)
(require-extension extras)
(require-extension lolevel)
(require-extension srfi-4)
(require-extension srfi-19-core)

(require-extension gl glu glut glm soil)

(define screen_width 800)
(define screen_height 600)

(require "common/opengl")
(require "common/vector")


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
      ; top
      -1.0  1.0  1.0
       1.0  1.0  1.0
       1.0  1.0 -1.0
      -1.0  1.0 -1.0
      ; back
       1.0 -1.0 -1.0
      -1.0 -1.0 -1.0
      -1.0  1.0 -1.0
       1.0  1.0 -1.0
      ; bottom
      -1.0 -1.0 -1.0
       1.0 -1.0 -1.0
       1.0 -1.0  1.0
      -1.0 -1.0  1.0
      ; left
      -1.0 -1.0 -1.0
      -1.0 -1.0  1.0
      -1.0  1.0  1.0
      -1.0  1.0 -1.0
      ; right
       1.0 -1.0  1.0
       1.0 -1.0 -1.0
       1.0  1.0 -1.0
       1.0  1.0  1.0
))

(define cube_texcoords 
    (let* ((a '(0.0 0.0 
                1.0 0.0 
                1.0 1.0 
                0.0 1))
           (vec (list->f32vector (append a a a a a a))))
      (print "Cube textcoords of size : " (f32vector-length vec))
      vec))

(define cube_elements (u16vector
    ; front
    0 1  2
    2 3  0
    ; top
    4 5  6
    6 7  4
    ; back
    8 9 10
    10 11  8
    ; bottom
    12 13 14
    14 15 12
    ; left
    16 17 18
    18 19 16
    ; right
    20 21 22
    22 23 20))

(define vbo_cube_vertices -1)
(define vbo_cube_texcoords -1)
(define ibo_cube_elements -1)

(define attribute_texcoord -1)
(define attribute_coord3d -1)
(define uniform_mvp -1)
(define uniform_mytexture -1)

(define texture_id -1)

(define (InitResources)
  (gl:Enable gl:BLEND)
  (gl:Enable gl:DEPTH_TEST)
  (gl:BlendFunc gl:SRC_ALPHA gl:ONE_MINUS_SRC_ALPHA)

  ; Load vbos
  (set! vbo_cube_vertices (CreateVBO32 gl:ARRAY_BUFFER gl:STATIC_DRAW cube_vertices))
  (set! vbo_cube_texcoords (CreateVBO32 gl:ARRAY_BUFFER gl:STATIC_DRAW cube_texcoords))
  (set! ibo_cube_elements (CreateVBO16 gl:ELEMENT_ARRAY_BUFFER gl:STATIC_DRAW cube_elements))

  ; Load textures
  (set! texture_id (CreateTexture gl:TEXTURE_2D (load-image "cubext/cube.png" force-channels/rgb)))

  ; Load shaders
  (define vs (CreateShader gl:VERTEX_SHADER (LoadScript "cubext/cube.v.glsl")))
  (define fs (CreateShader gl:FRAGMENT_SHADER (LoadScript "cubext/cube.f.glsl")))

  (set! program (CreateProgram (list vs fs)))

  (set! attribute_coord3d (gl:GetAttribLocation program "coord3d"))
  (set! attribute_texcoord (gl:GetAttribLocation program "texcoord"))
  (set! uniform_mvp (gl:GetUniformLocation program "mvp"))
  (set! uniform_mytexture (gl:GetUniformLocation program "mytexture"))

  (define endl "\n")

  (print "Init result\n"
    "Opengl error => (" (gl:GetError) ")" endl
    "Vertex shader: " vs endl
    "Fragment shader: " fs endl
    "Program: " program endl endl

    "VBOS: " endl
    "vbo_cube_texcoords: " vbo_cube_texcoords endl
    "vbo_cube_vertices: " vbo_cube_vertices endl
    "ibo_cube_elements: " ibo_cube_elements  endl

    "Attributes: " endl endl
    "attribute_coord3d: " attribute_coord3d endl
    "attribute_texcoord: " attribute_texcoord endl

    "Uniforms: " endl endl
    "uniform_mytexture: " uniform_mytexture endl
    "uniform_mvp: " uniform_mvp endl
  )

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

  (gl:UseProgram program)
  (gl:UniformMatrix4fv uniform_mvp 1 gl:FALSE (mat-data vp))

  (glut:PostRedisplay))

(define (reshapeFunc width height)
  ; Setting some globals 
  (set! screen_width width)
  (set! screen_height height)

  ; Defining gl viewport
  (gl:Viewport 0 0 width height)

  (print "Reshape func called"))
