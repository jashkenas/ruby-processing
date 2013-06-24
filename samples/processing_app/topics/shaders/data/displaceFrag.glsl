
uniform sampler2D colorMap;

varying vec4 vertTexCoord;

void main() {
  gl_FragColor = texture2D(colorMap, vertTexCoord.st);
}
