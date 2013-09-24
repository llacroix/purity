(require-extension gl glu glut)
(require-extension srfi-19-core)

(require "setup")
(require "inputs")
(require "renderer")

(let ((engine (makeEngine)))
  (glut:DisplayFunc renderFunc)
  (glut:KeyboardFunc keyboardFunc)
  (glut:ReshapeFunc reshapeFunc)
  (glut:IdleFunc idleFunc))

(glut:MainLoop)
