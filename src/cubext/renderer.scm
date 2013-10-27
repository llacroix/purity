(require-extension posix-extras)
(require-extension gl glu glut glm)
(require-extension srfi-4)
(require-extension srfi-19-core)
(require-extension lolevel)
(require "common/opengl-monkey")



(define (renderFunc)
  (gl:ClearColor 1 1 1 1)
  (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))

  (gl:UseProgram program)

  (gl:ActiveTexture gl:TEXTURE0)
  (gl:BindTexture gl:TEXTURE_2D texture_id)
  (gl:Uniform1i uniform_mytexture 0)

  (gl:EnableVertexAttribArray attribute_coord3d)
  (gl:EnableVertexAttribArray attribute_texcoord)

  (gl:BindBuffer gl:ARRAY_BUFFER vbo_cube_vertices)
  (gl:VertexAttribPointer 
     attribute_coord3d
     3
     gl:FLOAT
     gl:FALSE
     0
     0)

  (gl:BindBuffer gl:ARRAY_BUFFER vbo_cube_texcoords)
  (gl:VertexAttribPointer
     attribute_texcoord
     2
     gl:FLOAT
     gl:FALSE
     0
     0)

  (gl:BindBuffer gl:ELEMENT_ARRAY_BUFFER ibo_cube_elements)
  (let ((size (gl:GetBufferParameteriv gl:ELEMENT_ARRAY_BUFFER gl:BUFFER_SIZE)))
    (gl:DrawElements gl:TRIANGLES (/ size 2) gl:UNSIGNED_SHORT #f))


  (gl:DisableVertexAttribArray attribute_coord3d)
  (gl:DisableVertexAttribArray attribute_texcoord)

  (glut:SwapBuffers))
