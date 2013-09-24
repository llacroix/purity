; (declare (unit geo))

(require-extension gl glu glut)

(define (gl:Square x y r z)
  (let ((radius (/ r 2)))
    (for-each (lambda (angle)
        (gl:PushMatrix)
        (gl:Rotated angle 1 0 0)
        (gl:Translated x y z)
        (glut:SolidCube 0.5)
        ;(gl:Rotated angle 0 1 0)
        ;    (gl:Begin gl:TRIANGLE_STRIP)
        ;      (gl:Vertex3f (- x radius) (+ y radius) z)
        ;      (gl:Vertex3f (- x radius) (- y radius) z)
        ;      (gl:Vertex3f (+ x radius) (+ y radius) z)
        ;      (gl:Vertex3f (+ x radius) (- y radius) z)
        ;    (gl:End)
        (gl:PopMatrix)
        )
        '(0 45))))

