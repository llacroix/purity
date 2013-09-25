(define (keyboardFunc char x y)
  (if (equal? char #\esc)
    (begin
      (glut:LeaveGameMode)
      (exit))
  (print char " " x " " y)))
