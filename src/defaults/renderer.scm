(require-extension gl glu glut)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)

(define (with-matrix body)
  (gl:PushMatrix)
  (body)
  (gl:PopMatrix))

(define (draw-tail size angle cube-size)
  (with-matrix (lambda ()
    (gl:Rotated angle 0 1 0)
    (gl:Translated 0 0 -1)
    (glut:SolidCube cube-size)
    (if (not (= size 0))
      (draw-tail (- size 1) angle (- cube-size 0.05))))))

(define angle 0)
(define direction 0.01)
(define max-angle 10)
(define min-angle -10)

(define (next-angle)
  (if (or (> angle max-angle) (< angle min-angle))
    (set! direction (* -1 direction)))
  (set! angle (+ angle direction))
  angle)


(define (renderFunc)
  (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))

  (gl:LoadIdentity)
  (glu:LookAt 6 3 10
              0 0 0
              0 1 0)

  (draw-tail 20 (next-angle) 1.2)
  (glut:SolidCube 2)

  (for-each (lambda (obj)
    (with-matrix (lambda ()
      (gl:Translated (car obj) -1 (cadr obj))
      (glut:SolidCube 1))))
    '((1 1)
      (1 -1)
      (-1 1)
      (-1 -1)))

  (with-matrix (lambda ()
    (gl:Translatef 0 0.2 1)
    (glut:SolidCube 1)
    (with-matrix (lambda ()
      (gl:Translatef 0 0 2)
      (glut:SolidCube 1.5)))))

  ;(gl:DrawElements 1 1 1 (object->pointer (f32vector 1 2 3 4 6 7 6 8 9)))

  (gl:Flush)
  (glut:SwapBuffers))
