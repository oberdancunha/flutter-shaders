// https://thebookofshaders.com/09

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float drawCircle(in vec2 _uv, in float _radius) {
  vec2 l = _uv - vec2(0.5);

  return 1 - smoothstep(
    _radius - (_radius * 0.01),
    _radius + (_radius * 0.01),
    dot(l, l) * 4.0
  );
}

vec2 createSpaces(in vec2 _uv) {
  _uv *= 3.0;        // Scale up the space by 3
  _uv = fract(_uv);  // Wrap around 1.0

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);

  // Now we have 9 spaces that go from 0-1
  _uv = createSpaces(_uv);  
  float circle = drawCircle(_uv, 0.5);
  color = vec3(circle);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}