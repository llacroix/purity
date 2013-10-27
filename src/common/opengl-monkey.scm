; Save old function
(define gl:GetBufferParameterivOld gl:GetBufferParameteriv)

; Rebind Function to return an int
(define (gl:GetBufferParameteriv target value)
  (let ((size (s32vector 0)))
    (gl:GetBufferParameterivOld target value size)
    (s32vector-ref size 0)))

