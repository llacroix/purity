(use missbehave missbehave-matchers missbehave-stubs miscmacros)
(require "../../../src/common/utils/string-port")

(define Make-Port (lambda ()
  (string-port
"A
B
C
D
EF
G
H")))

(describe "String ports"

    (it "can read lines"
        (define str-port (Make-Port))

        (expect (read-line str-port) (is "A"))
        (expect (read-line str-port) (is "B"))
        (expect (read-line str-port) (is "C"))
        (expect (read-line str-port) (is "D"))
        (expect (read-line str-port) (is "EF"))
        (expect (read-line str-port) (is "G"))
        (expect (read-line str-port) (is "H"))
        (expect (read-line str-port) (is #!eof))
        (expect (read-line str-port) (is #!eof))
        (expect (read-line str-port) (is #!eof)))

    (it "can read chars"
        (define str-port (Make-Port))

        (expect (read-char str-port) (is #\A))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\B))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\C))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\D))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\E))
        (expect (read-char str-port) (is #\F))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\G))
        (expect (read-char str-port) (is #\newline))
        (expect (read-char str-port) (is #\H))
        (expect (read-char str-port) (is #!eof))
        (expect (read-char str-port) (is #!eof))
        (expect (read-char str-port) (is #!eof))
        (expect (read-char str-port) (is #!eof))))
