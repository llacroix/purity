(import foreign)
(require-extension lolevel)
(require-extension gl glu glut)
(require-extension srfi-19-core)

(define vbo_triangle 0)
(define program 0)
(define attribute_coord2d 0)

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
      (gl:GetProgramiv program gl:LINK_STATUS status)
      (print status))

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
     (glut:InitWindowSize 800 600)
     (glut:CreateWindow "simple")
    ; (glut:GameModeString "1024x768:32")
    ; (glut:EnterGameMode)
    (glut:InitDisplayMode (+ glut:DOUBLE  glut:RGBA  glut:DEPTH glut:ALPHA))
    #t)

(define (idleFunc)
  (glut:PostRedisplay))

(define (initFunc)
  ; (gl:ShadeModel gl:SMOOTH)
  (gl:ClearColor 1 1 1 1)
  ; (gl:ClearDepth 1)
  ; (gl:Enable gl:DEPTH_TEST)
  ; (gl:DepthFunc gl:LEQUAL)
  ; (gl:BindBuffer 0 0)
  ;
  (set! vbo_triangle (CreateVBO (f32vector  0.0 0.8 -0.8 -0.8 0.8 -0.8)))

  (set! program (CreatePorgram (list
      (CreateShader gl:VERTEX_SHADER
        "#version 120
        attribute vec2 coord2d;

        void main(void) {
          gl_Position = vec4(coord2d, 0.0, 1.0);
        }")

      (CreateShader gl:FRAGMENT_SHADER
        "#version 120
        void main(void) {
          gl_FragColor[0] = 0.0;
          gl_FragColor[1] = 0.0;
          gl_FragColor[2] = 1.0;
        }"))))

  (set! attribute_coord2d (gl:GetAttribLocation program "coord2d"))
  (print "Attr coord2" attribute_coord2d)
  (print (gl:GetError))
  (print (gl:GetString gl:EXTENSIONS))
  ; (gl:Hint gl:PERSPECTIVE_CORRECTION_HINT gl:NICEST))
  )

(define (reshapeFunc width height)
  (initFunc)

  ; (gl:Viewport 0 0 width height)
  ; (gl:MatrixMode gl:PROJECTION)
  ; (gl:LoadIdentity)
  ; (glu:Perspective 45 (/ width height) 0.1 100)
            
  ; (gl:MatrixMode gl:MODELVIEW)
  ; (gl:LoadIdentity)

  ; (gl:Enable gl:LIGHTING)
  ; (gl:Enable gl:LIGHT0)
  ; (gl:Enable gl:DEPTH_TEST)
  (gl:Enable gl:BLEND)
  (gl:BlendFunc gl:SRC_ALPHA gl:ONE_MINUS_SRC_ALPHA)

  (print "Reshape func called"))
