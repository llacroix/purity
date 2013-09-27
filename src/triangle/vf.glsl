void main(void) {
  gl_FragColor = vec4(0,0,1,1);

  gl_FragColor[0] = gl_FragCoord.x / 600.0;
  gl_FragColor[1] = gl_FragCoord.y / 600.0;
  gl_FragColor[2] = gl_FragCoord.z / 100.0;
}
