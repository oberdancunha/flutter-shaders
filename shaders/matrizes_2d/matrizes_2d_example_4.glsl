// https://thebookofshaders.com/08/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

// YUV to RGB matrix
mat3 yuv2rgb = mat3(
  1.0, 0.0, 1.13983,
  1.0, -0.39465, -0.58060,
  1.0, 2.03211, 0.0
);

vec2 remapUvZero2One(in vec2 _uv) {
  // UV values goes from -1 to 1
  // So we need to remap uv (0.0 to 1.0)
  _uv -= 0.5; // becomes -0.5 to 0.5
  _uv *= 2.0; // becomes -1.0 to 1.0

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  _uv = remapUvZero2One(_uv);

  // we pass uv as the y & z values of
  // a three dimensional vector to be
  // properly multiply by a 3x3 matrix
  color = yuv2rgb * vec3(0.5, _uv.x, -_uv.y);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}