(require-extension ports)
(require-extension extras)

; Create a port that could be used with a string.
; You can send this port to any function that requires a 
; port
(define (string-port str)
  (let ((pos -1))
    ; Check if we reached the last char in our string
    (define (ready)
      (< pos (string-length str)))

    ; Return next char until we reach the last one and return eof
    (define (read-char)
      (set! pos (+ pos 1))
      (if (ready)
        (string-ref str pos)
        #!eof))

    ; Close function that does nothing
    (define (close)
      #t)

    ; Make our input port
    (make-input-port read-char ready close)))
