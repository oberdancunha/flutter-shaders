// https://thebookofshaders.com/07/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float box(in vec2 _uv, in vec2 _size) {
  _size = vec2(0.5) - _size * 0.5;
  vec2 uv = smoothstep(
    _size,
    _size + vec2(1e-4),
    _uv
  );
  uv *= smoothstep(
    _size,
    _size + vec2(1e-4),
    vec2(1.0) - _uv
  );
  
  return uv.x * uv.y;
}

vec3 drawSquare(in vec2 _uv) {
  vec3 color = vec3(0.0);
  color = vec3(
    box(
      _uv,
      vec2(0.9)
    )
  );

  return color;
}

float checkLineEvenOrOdd(in vec2 _uv) {
  // return 0 is even
  // return 1 is odd: move the line
  return step(1.0, mod(_uv.y, 2.0));
}

vec2 applyOffsetOddRows(in vec2 _uv) {
  _uv.x += checkLineEvenOrOdd(_uv) * 0.5;

  return _uv;
}

vec2 brickTile(in vec2 _uv, in float _zoom) {
  _uv *= _zoom;
  _uv = applyOffsetOddRows(_uv);

  return fract(_uv);
}

vec2 makeModernBrick(in vec2 _uv) {
  _uv /= vec2(2.15, 0.65) / 1.5;

  return _uv;
}

vec2 invertBrick(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv = invertBrick(_uv);
  _uv = makeModernBrick(_uv);
  _uv = brickTile(_uv, 5.0);
  vec3 color = drawSquare(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}