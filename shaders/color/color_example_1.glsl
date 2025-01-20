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

vec3 fragment(vec2 uv) {
    vec3 color = vec3(0.0);
    float correctIOSIndexRange = uv.x - uv.x;
    float pct = abs(sin(uTime + correctIOSIndexRange));

    // Mix uses pct (a value from 0-1) to
    // mix the two colors
    color = mix(colorA, colorB, pct);

    return color;
}

void main() { 
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    fragColor = vec4(fragment(uv), 1.0);
}
