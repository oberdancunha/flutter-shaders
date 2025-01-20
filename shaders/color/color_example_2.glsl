// https://thebookofshaders.com/06/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 colorA = vec3(0.149, 0.141, 0.912);
vec3 colorB = vec3(1.000, 0.833, 0.224);

float plot(vec2 uv, float pct) {
  return smoothstep(pct + 0.01, pct, uv.y) - smoothstep(pct, pct - 0.01, uv.y);
}

vec3 fragment(vec2 uv) {
  vec3 color = vec3(0.0);
  float correctIOSIndexRange = uTime - uTime;
  vec3 pct = vec3(uv.x + correctIOSIndexRange);
  color = mix(colorA, colorB, pct);

  // Plot transition lines for each channel
  color = mix(color, vec3(1.0, 0.0, 0.0), plot(uv, 1.0 - pct.r));
  color = mix(color, vec3(0.0, 1.0, 0.0), plot(uv, 1.0 - pct.g));
  color = mix(color, vec3(0.0, 0.0, 1.0), plot(uv, 1.0 - pct.b));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  fragColor = vec4(fragment(uv), 1.0); 
}

