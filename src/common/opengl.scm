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
