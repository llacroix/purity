(require-extension posix-extras)
(require-extension gl glu glut glm)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)

(define old 0)

(define (renderFunc)
  (gl:ClearColor 1 1 1 1)
  (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))

  (gl:UseProgram program)

  (gl:EnableVertexAttribArray attribute_coord3d)
  (gl:BindBuffer gl:ARRAY_BUFFER vbo_cube_vertices)
  (gl:VertexAttribPointer 
     attribute_coord3d
     3
     gl:FLOAT
     gl:FALSE
     0
     #f)

  (gl:EnableVertexAttribArray attribute_v_color)
  (gl:BindBuffer gl:ARRAY_BUFFER vbo_cube_colors)
  (gl:VertexAttribPointer
     attribute_v_color
     3
     gl:FLOAT
     gl:FALSE
     0
     #f)

  (define model (translate anim (vec3 0 0 -4)))
  (define model2 (rotate (translate anim (vec3 1 1 -4)) 10
                 (vec3 1 0 0)))

  (define (cuber count matrix)
    (define mvp (if (= (modulo count 2) 0)
                    (m* matrix model)
                    (m* matrix model2)))

    (gl:UseProgram program)
    (gl:UniformMatrix4fv uniform_mvp 1 gl:FALSE (mat-data mvp))
    (gl:BindBuffer gl:ELEMENT_ARRAY_BUFFER ibo_cube_elements)

    (let ((size (s32vector 0)))
      (gl:GetBufferParameteriv gl:ELEMENT_ARRAY_BUFFER gl:BUFFER_SIZE size)
      (gl:DrawElements gl:TRIANGLES (/ (s32vector-ref size 0) 2) gl:UNSIGNED_SHORT #f))

    (if (> count 0)
      (cuber (- count 1) mvp)))

  (cuber 10 vp)

  (gl:DisableVertexAttribArray attribute_coord3d)
  (gl:DisableVertexAttribArray attribute_v_color)

  ;(print (- (glut:Get glut:ELAPSED_TIME) old))
  ;(set! old (glut:Get glut:ELAPSED_TIME))

  (glut:SwapBuffers))
