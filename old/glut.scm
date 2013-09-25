(require-extension gl glu glut)
(require-extension srfi-19-core)

; (declare (uses geo))
(require "geometry")

(define old-time (time->nanoseconds (current-time)))
(define text "")
(define PI (acos -1))
(define RAD (/ PI 360))
(define minirad (/ RAD 3))
(define angle 0)
(define distance 10)

; (glut:InitWindowSize 800 600)
; (glut:CreateWindow "simple")
; (glut:GameModeString "1024x768:32")
(glut:EnterGameMode)
(glut:InitDisplayMode (+ glut:DOUBLE  glut:RGB  glut:DEPTH))

; Setup our objects

(define (build-list)
  (let ((sq (list)))
    (for-each (lambda (x)
      (for-each (lambda (y)
        (set! sq (append sq `((,x ,y ,(random 4))))))
        '(-4 -3 -2 -1 0 1 2 3 4)))
      '(-4 -3 -2 -1 0 1 2 3 4))
    sq))

(define squares (build-list))

(glut:DisplayFunc
  (lambda () (time
   (print "Start render")
   (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))

   (gl:LoadIdentity)
   (gl:Translatef 0  0 -6)


   (set! angle (+ angle minirad))

   (glu:LookAt (* (cos angle) distance) 3 (* (sin angle) distance)
               0  0 0
               0  1 0)

   (gl:PushMatrix)
   (gl:Rotatef -45 1 0 0)

   (for-each (lambda (tuple)
       (gl:Color3f 1 0 0)
       (gl:Square (list-ref tuple 0) 
                  (list-ref tuple 1)
                  0.9 
                  (list-ref tuple 2)))
     squares)

   (gl:Color3f (cos angle) (sin angle) (* (cos angle) (sin angle)))
   (gl:Square (* (cos angle) 4) (* (sin angle) 4) 2 0.5)
   (gl:PopMatrix)

   (glut:SolidSphere 100 100 100)

   (gl:Flush))))

(glut:KeyboardFunc
  (lambda (char x y)
    (if (equal? char #\esc)
      (begin
        (glut:LeaveGameMode)
        (exit))
      (set! squares (build-list)))

    (set! text (string-append text (string char)))

    (print text)
    (print char " " x " " y)))

(glut:ReshapeFunc
  (lambda (width height) 
    (glInit)

    (gl:Viewport 0 0 width height)
    (gl:MatrixMode gl:PROJECTION)
    (gl:LoadIdentity)
    (glu:Perspective 45 (/ width height) 0.1 100)

    (gl:ClearColor 0 0 0 1)
              
    (gl:MatrixMode gl:MODELVIEW)
    (gl:LoadIdentity)

    (print "Reshape func called")))

(glut:IdleFunc
  (lambda ()
    (glut:PostRedisplay)))

(define (glInit)
  (gl:ShadeModel gl:SMOOTH)
  (gl:ClearColor 0 0 0 1)
  (gl:ClearDepth 1)
  (gl:Enable gl:DEPTH_TEST)
  (gl:DepthFunc gl:LEQUAL)
  (gl:Hint gl:PERSPECTIVE_CORRECTION_HINT gl:NICEST))

(glut:MainLoop)
