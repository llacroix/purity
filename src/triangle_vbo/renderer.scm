(require-extension posix-extras)
(require-extension gl glu glut glm)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)
(require "common/opengl-monkey")

(define vertices (f32vector 0.0  0.8
                            -0.8 -0.8
                            0.8  -0.8))

(define (renderFunc)
  (gl:ClearColor 1 1 1 1)
  (gl:Clear gl:COLOR_BUFFER_BIT)

  (let ()
     (print "Render program " program)
     (print "Render attr coord " attribute_coord2d))

  (gl:UseProgram program)

  (gl:EnableVertexAttribArray attribute_coord2d)
  (gl:VertexAttribPointer 
     attribute_coord2d
     2
     gl:FLOAT
     #\0
     0
     vertices)


  (gl:DrawArrays gl:TRIANGLES 0 3)

  (gl:DisableVertexAttribArray attribute_coord2d)

  (glut:SwapBuffers))
