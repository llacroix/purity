varying vec2 f_texcoord;
uniform sampler2D mytexture;

void main(void) {
  vec2 flipped_texcoord = vec2(f_texcoord.x, 1.0 - f_texcoord.y);
  gl_FragColor = texture2D(mytexture, flipped_texcoord);

  gl_FragColor[0] = 1.0 - gl_FragColor[0];
  gl_FragColor[1] = 1.0 - gl_FragColor[1];
  gl_FragColor[2] = 1.0 - gl_FragColor[2];
}
