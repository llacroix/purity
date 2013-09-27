(import foreign)
(require-extension extras)
(require-extension lolevel)
(require-extension gl glu glut)
(require-extension srfi-19-core)

(require "common/opengl")

(define vbo_triangle 0)
(define program 0)
(define uniform 0)
(define attribute_coord3d 0)

(define (makeEngine)
  (glut:InitDisplayMode (+ glut:DOUBLE  glut:RGBA  glut:DEPTH glut:ALPHA))
  (glut:InitWindowSize 800 600)
  (glut:CreateWindow "simple")
  #t)

(define (idleFunc)
  (glut:PostRedisplay))

(define (initFunc)
  (print "Init")
  (gl:ClearColor 1 1 1 1)

  (gl:Enable gl:TEXTURE_2D) 
  (gl:Enable gl:LIGHTING)
  (gl:Enable gl:BLEND)
  (gl:Enable gl:DEPTH_TEST)

  (gl:BlendFunc gl:SRC_ALPHA gl:ONE_MINUS_SRC_ALPHA)

  ; (set! vbo_triangle (CreateVBO (f32vector  0.0 0.8 -0.8 -0.8 0.8 -0.8)))
  (set! program (CreateProgram (list
      (CreateShader gl:VERTEX_SHADER (LoadScript "triangle/vs.glsl"))
      (CreateShader gl:FRAGMENT_SHADER (LoadScript "triangle/vf.glsl")))))

  (set! uniform (gl:GetUniformLocation program "m_mvp"))
  (set! attribute_coord3d (gl:GetAttribLocation program "coord3d"))

  (print "attribute_coord3d: " attribute_coord3d)
  (print "uniform: " uniform)
  (print "vbo_triangle: " vbo_triangle)
  (print "program: " program)

  (print (gl:GetError))
  (print (gl:GetString gl:EXTENSIONS)))


(define (reshapeFunc width height)
  (initFunc)

  (set! swidth width)
  (set! sheight height)
  (gl:Viewport 0 0 width height)
            
  (print "Reshape func called"))
