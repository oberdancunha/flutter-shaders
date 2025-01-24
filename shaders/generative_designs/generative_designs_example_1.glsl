// https://thebookofshaders.com/10/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float random(in vec2 _uv) {
  return fract(
    sin(
      dot(
        _uv.xy,
        vec2(
          12.9898,
          78.233
        )
      )
    ) * 43758.5453123
  );
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  float rnd = random(_uv);
  color = vec3(rnd);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}