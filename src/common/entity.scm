(require "deps")

(define-record entity id position orientation)
(define-record attribute type pointer)

(define (buffer-for entity type)
  )

(define (attribute-for entity type)
  )

(define (attributes-for entity)
  )

(define (texture-for entity)
  )

(define (uniform-for entity type)
  )

(define (use-texture entity)
  (let ((texture_id (texture-for entity))
        (uniform_texture (uniform-for entity 'texture)))

      (gl:ActiveTexture gl:TEXTURE0)
      (gl:BindTexture gl:TEXTURE_2D texture_id)
      (gl:Uniform1i uniform_texture 0)))

(define (enable-attributes-for entity)
  (for-each (lambda (attribute)
    (gl:EnableVertexAttribArray attribute))
    (attributes-for entity)))
    
(define (disable-attributes-for entity)
  (for-each (lambda (attribute)
    (gl:DisableVertexAttribArray attribute)
    (attributes-for entity)))

(define (use-buffer entity type)
  
  (let* ((vbo (buffer-for entity type))
         (attribute (attribute-for entity type))
         (size (attribute-size attribute))
         (pointer (attribute-pointer attribute)))

    (gl:BindBuffer gl:ARRAY_BUFFER vbo)
    (gl:VertexAttribPointer 
        pointer
        size
        gl:FLOAT
        gl:FALSE
        0
        #f)))

(define (draw-elements entity)
  (let ((ibo (buffer-for entity 'elements))
        (size (s32vector 0)))

    (gl:BindBuffer gl:ELEMENT_ARRAY_BUFFER ibo)

    (gl:GetBufferParameteriv gl:ELEMENT_ARRAY_BUFFER
                             gl:BUFFER_SIZE
                             size)

    (gl:DrawElements gl:TRIANGLES 
                     (/ (s32vector-ref size 0) 2) 
                     gl:UNSIGNED_SHORT
                     #f))

(define (draw entity)
  (gl:UseProgram (program-for entity))

  (use-texture entity)

  (enable-attributes-for entity)

  (use-buffer entity 'geometry)
  (use-buffer entity 'texture)

  (draw-elements entity)

  (disable-attributes-for entity))

