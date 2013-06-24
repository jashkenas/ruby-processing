#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec4 col = texture2D(texture, vertTexCoord.st);
  float lum = dot(col, lumcoeff);
  if (0.5 < lum) {
    gl_FragColor = vertColor;
  } else {
    gl_FragColor = vec4(0, 0, 0, 1);
  }     
}