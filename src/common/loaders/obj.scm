(require-extension srfi-4 extras srfi-13
                   list-utils)

(define (load-obj filename)

  (define (to-numbers lst)
    (map string->number lst))

  ; Check for 1, 1/2, 1/2/3, 1//2
  ; Only use the vertex index because 
  ; I have no idea how to draw elements with different
  ; normal/texture indexes...
  (define (parse-vertex lst)
    (to-numbers
      (map (lambda (str)
        (car (string-split str "/" #t))) lst)))
      
  ; Simply convert string to numbers
  (define parse-normal to-numbers)

  ; Reduce by one since the indices start by 1 instead of 
  ; 0
  (define (parse-element lst)
    (map (lambda (x) (- x 1)) (to-numbers lst)))

  ; Parse texcoord, if w is missing we add 0 in case it matters
  ; while I believe I should just trim it to u, v instead of adding w
  ; which is meaningless in OpenGL as far as I know
  (define (parse-texcoord lst)
    (let ((uvs (to-numbers lst)))
      (if (= (length uvs) 2)
        (append uvs (list 0))
        uvs)))

  (call-with-input-file filename
    (lambda (file)
      ; A recursive let to iteratively replace our parameters
      (let parse ((line (read-line file))
                  (name "")
                  (vertices (list))
                  (texcoords (list))
                  (normals (list))
                  (elements (list)))

        (if (equal? line #!eof)

          ; Return a list of everything once done
          (list name vertices texcoords normals elements)

          (let* ((tokens (string-tokenize line))
                 (type (car tokens))
                 (lst (cdr tokens)))

            ; Recursively loop returning the result of the recursion
            ; Should check only once every one of tests and recall parse
            ; with all identical parameters if nothing tested to true
            ; should make the code a little bit faster
            (parse (read-line file)
                   (if (equal? type "o") (cadr tokens) name)
                   (if (equal? type "v") (append vertices (parse-vertex lst)) vertices)
                   (if (equal? type "vt") (append texcoords (parse-texcoord lst)) texcoords)
                   (if (equal? type "vn") (append normals (parse-normal lst)) normals)
                   (if (equal? type "f") (append elements (parse-element lst)) elements))))))))

; (print (load-obj "./suzanne.obj"))
