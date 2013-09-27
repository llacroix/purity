varying vec3 f_color;

void main(void) {
  gl_FragColor = vec4(f_color.x * cos(gl_FragCoord.y) * 3.0,
                      f_color.y * cos(gl_FragCoord.z + 1.0) * 5.0, 
                      f_color.z * sin(gl_FragCoord.x) * 2.0, 1.0);
}
