// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float random (in vec2 _uv) {
  return fract(
    sin(
      dot(
        _uv.xy,
        vec2(12.9898, 78.233)
      )
    ) * 43758.5453123
  );
}

vec2 makeHermineCurve(in vec2 _f) {
  return _f * _f * (3.0 - (2.0 * _f));
}

float noise(in vec2 _uv) {
  vec2 i = floor(_uv);
  vec2 f = fract(_uv);

  // Four corners in 2D of a tile
  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = makeHermineCurve(f);

  return mix(a, b, u.x) + 
  (c - a)* u.y * (1.0 - u.x) + 
  (d - b) * u.x * u.y;
}

vec3 makeColor(in vec2 _uv) {
  _uv.y = 1.0 -_uv.y;
  vec3 color = vec3(0.0);
  vec2 pos = vec2(_uv * 5.0);
  float n = noise(pos);
  color = vec3(n);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}