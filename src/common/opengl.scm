(require-extension gl glu glut)

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
    (gl:BufferData gl:ARRAY_BUFFER (f32vector-size vertices) (make-locative vertices) gl:STATIC_DRAW)
    (print "VBO id: " vboidx)
    (u32vector-ref vboidx 0)))

(define (CreateVBO32 type mode vertices)
  (let ((vboidx (u32vector 0)))
    (gl:GenBuffers 1 vboidx)
    (gl:BindBuffer type (u32vector-ref vboidx 0))
    (gl:BufferData type
                   (f32vector-size vertices)
                   (make-locative vertices)
                   mode)
    (print "VBO id: " vboidx)
    (u32vector-ref vboidx 0)))

(define (CreateVBO16 type mode vertices)
  (let ((id (u32vector 0)))
     (gl:GenBuffers 1 id)
     (gl:BindBuffer type 
                    (u32vector-ref id 0))
     (gl:BufferData type 
                    (* 2 (u16vector-length vertices))
                    (make-locative vertices)
                    mode)
     (print "VBO id: " id)
     (u32vector-ref id 0)))

(define (CreateProgram shaders)
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
      (print "Shader status" status))

    shader))
