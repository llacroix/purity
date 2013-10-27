(require-extension posix-extras)
(require-extension gl glu glut glm)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)
(require "common/opengl-monkey")


(define swidth 1)
(define sheight 1)

(define projection (perspective 45.0 (* 1.0 (/ swidth sheight)) 0.01 100.0))
(define view (look-at (vec3 0 0 -50)
                      (vec3 0 0 0)
                      (vec3 0 1 0)))
(define rotangle 0)


(define (SetMatrix inModel)
  (gl:UseProgram program)
  (gl:UniformMatrix4fv uniform 1 #\0 (mat-data (m* (m* projection view) inModel))))

(define (renderFunc)
  (gl:UniformMatrix4fv uniform 1 #\0 (mat-data (m* projection view)))

  (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))

  (define model  (translate (mat4 1) (vec3 -10 0 0)))
  (define model1 (translate (mat4 1) (vec3 10 0 0)))

  (SetMatrix model)
  (gl:EnableVertexAttribArray attribute_coord3d)
  (gl:Begin gl:TRIANGLES)
    (gl:Vertex3f  0  1 0)
    (gl:Vertex3f -1 -1 0)
    (gl:Vertex3f  1 -1 0)
  (gl:End)
  (gl:DisableVertexAttribArray attribute_coord3d)

  (SetMatrix model1)
  (gl:EnableVertexAttribArray attribute_coord3d)
  (gl:Begin gl:TRIANGLES)
    (gl:Vertex3f  0  1 0)
    (gl:Vertex3f -1 -1 0)
    (gl:Vertex3f  1 -1 0)
  (gl:End)
  (gl:DisableVertexAttribArray attribute_coord3d)

  (gl:UniformMatrix4fv uniform 1 #\0 (mat-data (mat4 1)))
  (glut:SwapBuffers))
