// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec2 random2(vec2 _uv) {
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
      dot(
        random2(i + vec2(0.0, 0.0)),
        f - vec2(0.0, 0.0)
      ),
      dot(
        random2(i + vec2(1.0, 0.0)),
        f - vec2(1.0, 0.0)
      ),
      u.x
    ),
    mix(
      dot(
        random2(i + vec2(0.0, 1.0)),
        f - vec2(0.0, 1.0)
      ),
      dot(
        random2(i + vec2(1.0, 1.0)),
        f - vec2(1.0, 1.0)
      ),
      u.x
    ),
    u.y
  );
}

float makeHolesOnSplatter(in vec2 _uv) {
  return smoothstep(0.35, 0.4, noise(_uv * 10.0));
}

float makeBlackSplatter(in vec2 _uv) {
  return smoothstep(0.15, 0.2, noise(_uv * 10.0));
}

vec3 makeBigBlackDrops(in vec2 _uv) {
  return vec3(1.0) * smoothstep(0.18, 0.2, noise(_uv));
}

float makeAnimation() {
  return abs(1.0 - sin(uTime * 0.1)) * 5.0;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  float t = 1.0;
  t = makeAnimation();
  _uv += noise(_uv * 2.0) * t;
  color = makeBigBlackDrops(_uv);
  color += makeBlackSplatter(_uv);
  color -= makeHolesOnSplatter(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  uv.x *= uSize.x / uSize.y;
  vec3 color = makeColor(uv);
  fragColor = vec4(1.0 - color, 1.0);
}