uniform mat4 m_mvp;
attribute vec4 coord3d;

void main(void) {
      gl_Position = m_mvp * vec4(coord3d.xyz, 1.0);
}
