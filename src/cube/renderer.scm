(require-extension posix-extras)
(require-extension gl glu glut)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)

(define (renderFunc)
  (gl:Clear gl:COLOR_BUFFER_BIT)

  (gl:LoadIdentity)
  (glu:LookAt 6 3 10
              0 0 0
              0 1 0)
  (gl:UseProgram program)
  (gl:EnableVertexAttribArray attribute_coord2d)

  (gl:VertexAttribPointer
    attribute_coord2d
    3
    gl:FLOAT
    #\0
    0
    #f)

  ; (glut:SolidCube 1)

  (gl:PushMatrix)
  (gl:Rotated 90 1 0 1)
  (gl:Begin gl:TRIANGLES)
    (gl:Vertex3f 0.0 0.8 1)
    (gl:Vertex3f -0.8 -0.8 1)
    (gl:Vertex3f 0.8 -0.8 -1)
  (gl:End)
  (gl:PopMatrix)

  (gl:DisableVertexAttribArray attribute_coord2d)

  (sleep 0.5)

  (glut:SwapBuffers))
