// https://thebookofshaders.com/06/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb(in vec3 c) {
  vec3 rgb = clamp(
    abs(
        mod(
          c.x * 6.0 + vec3(0.0, 4.0, 2.0),
          6.0
        ) - 3.0
      ) - 1.0,
      0.0,
      1.0
    );
  rgb = rgb * rgb * (3.0 - 2.0 * rgb);


  return c.z * mix(vec3(1.0), rgb, c.y);
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = vec3(0.0);
  
  // We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
  // And the y (0.0 - 1.0) to the brightness
  color = hsb2rgb(
      vec3(uv.x, 1.0, 1.0 - uv.y)
    );
  
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}
