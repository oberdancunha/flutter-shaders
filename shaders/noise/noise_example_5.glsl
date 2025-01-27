// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec2 random2(in vec2 _uv) {
  _uv = vec2(
    dot(
      _uv,
      vec2(127.1, 311.7)
    ),
    dot(
      _uv,
      vec2(269.5, 183.3)
    )
  );

  return -1.0 + 2.0 * fract(sin(_uv) * 43758.5453123);
}

vec2 makeHermineCurve(in vec2 _f) {
  return _f * _f * (3.0 - (2.0 * _f));
}

vec2 getFractionalCoords(in vec2 _uv) {
  return fract(_uv);
}

vec2 getIntegerCoords(in vec2 _uv) {
  return floor(_uv);
}

float noise(in vec2 _uv) {
  vec2 i = getIntegerCoords(_uv);
  vec2 f = getFractionalCoords(_uv);
  vec2 u = makeHermineCurve(f);

  return mix(
    mix(
      dot(random2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
      dot(random2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)),
      u.x
    ),
    mix(
      dot(random2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
      dot(random2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)),
      u.x
    ), 
    u.y
  );
}

float shape(in vec2 _uv, in float _radius) {
  _uv = vec2(0.5) - _uv;
  float r = length(_uv) * 2.0;
  float a = atan(_uv.y, _uv.x);
  float m = abs(
    mod(
      a + (uTime * 2.0),
      3.14 * 2.0
    ) - 3.14
  ) / 3.6;
  float f = _radius;
  m += noise(_uv + (uTime * 0.1)) * 0.5;
  f += sin(a * 50.0) * noise(_uv + uTime * 0.2) * 0.1;
  f += (sin(a * 20.0) * 0.1 * pow(m, 2.0));
  
  return 1.0 - smoothstep(f, f + 0.007, r);
}

float shapeBorder(in vec2 _uv, in float _radius, in float _width) {
  return shape(_uv, _radius) - shape(_uv, _radius - _width);
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
	color = vec3(1.0) * shapeBorder(_uv, 0.8, 0.02);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(1.0 - color, 1.0);
}