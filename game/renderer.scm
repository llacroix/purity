(require-extension gl glu glut)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)

(define (with-matrix body)
  (gl:PushMatrix)
  (body)
  (gl:PopMatrix))

(define angle 0)
(define direction 0.1)
(define max-angle 10)
(define min-angle -10)

(define (next-angle)
  (if (or (> angle max-angle) (< angle min-angle))
    (set! direction (* -1 direction)))
  (set! angle (+ angle direction))
  angle)


(define (renderFunc)
  (gl:Clear (+ gl:COLOR_BUFFER_BIT))

  ; (gl:LoadIdentity)
  ; (glu:LookAt 6 3 10
  ;             0 0 0
  ;             0 1 0)

  (gl:UseProgram program)
  (gl:EnableVertexAttribArray attribute_coord2d)
  (gl:BindBuffer gl:ARRAY_BUFFER vbo_triangle)
  (gl:VertexAttribPointer
    attribute_coord2d 
    2
    gl:FLOAT
    #\0
    0
    (object->pointer #f))

  (gl:DrawArrays gl:TRIANGLES 0 3)
  (gl:DisableVertexAttribArray attribute_coord2d)

  (gl:Flush)
  (glut:SwapBuffers))
