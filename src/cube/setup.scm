(import foreign)
(require-extension extras)
(require-extension lolevel)
(require-extension gl glu glut)
(require-extension srfi-19-core)

(define vbo_triangle 0)
(define program 0)
(define attribute_coord2d 0)

(define (LoadScript filename)
  (call-with-input-file filename
    (lambda (p)
      (let f ((x (read-line p)))
        (if (eof-object? x)
          ""
          (string-append x "\n" (f (read-line p))))))))

(define (CreateVBO vertices)
  (let ((vboidx (u32vector 0)))
    (gl:GenBuffers 1 vboidx)
    (gl:BindBuffer gl:ARRAY_BUFFER (u32vector-ref vboidx 0))
    (gl:BufferData gl:ARRAY_BUFFER (* 4 (f32vector-length vertices)) (object->pointer vertices) gl:STATIC_DRAW)
    (u32vector-ref vboidx 0)))

(define (CreatePorgram shaders)
  (let ((program (gl:CreateProgram)))
    (for-each (lambda (shader)
                (gl:AttachShader program shader))
              shaders)
    (gl:LinkProgram program)

    (let ((status (s32vector 0)))
      (gl:GetProgramiv program gl:LINK_STATUS status))

    program))

(define (CreateShader type text)
  (let ((shader (gl:CreateShader type)))
    (gl:ShaderSourceOne shader text)
    (gl:CompileShader shader)

    (let ((status (s32vector 0)))
      (gl:GetShaderiv shader gl:COMPILE_STATUS status)
      (print status))

    shader))

(define (makeEngine)
  (glut:InitDisplayMode (+ glut:DOUBLE  glut:RGBA  glut:DEPTH glut:ALPHA))
  (glut:InitWindowSize 800 600)
  (glut:CreateWindow "simple")
  #t)

(define (idleFunc)
  (glut:PostRedisplay))

(define (initFunc)
  (gl:ClearColor 1 1 1 1)

  (gl:Enable gl:TEXTURE_2D) 
  (gl:Enable gl:LIGHTING)
  (gl:Enable gl:BLEND)
  (gl:BlendFunc gl:SRC_ALPHA gl:ONE_MINUS_SRC_ALPHA)

  (set! vbo_triangle (CreateVBO (f32vector  0.0 0.8 -0.8 -0.8 0.8 -0.8)))
  (set! program (CreatePorgram (list
      (CreateShader gl:VERTEX_SHADER (LoadScript "triangle/vs.glsl"))
      (CreateShader gl:FRAGMENT_SHADER (LoadScript "triangle/vf.glsl")))))

  (set! attribute_coord2d (gl:GetAttribLocation program "coord2d"))

  (print "attribute_coord2d: " attribute_coord2d)
  (print "vbo_triangle: " vbo_triangle)
  (print "program: " program)

  (print (gl:GetError))
  (print (gl:GetString gl:EXTENSIONS)))


(define (reshapeFunc width height)
  (initFunc)

  (gl:Viewport 0 0 width height)
  (gl:MatrixMode gl:PROJECTION)
  (gl:LoadIdentity)
  (glu:Perspective 45 (/ width height) 0.1 100)
            
  (gl:MatrixMode gl:MODELVIEW)
  (gl:LoadIdentity)

  (print "Reshape func called"))
