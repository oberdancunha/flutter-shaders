// https://thebookofshaders.com/10/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float makeMaze(in vec2 _tile) {
  float maze = 0.0;
  maze = smoothstep(
    _tile.x - 0.3,
    _tile.x,
    _tile.y
  ) - smoothstep(
    _tile.x,
    _tile.x + 0.3,
    _tile.y
  );

  return maze;
}

float random (in vec2 _uv) {
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

vec2 truchetPattern(in vec2 _uv, in float _index) {
  _index = fract(((_index - 0.5) * 2.0));
  if (_index > 0.75) {
    return vec2(1.0) - _uv;
  }
  if (_index > 0.5) {
    return vec2(1.0 - _uv.x, _uv.y);
  }
  if (_index > 0.25) {
    return 1.0 - vec2(1.0 - _uv.x, _uv.y);
  }

  return _uv;
}

vec2 getFractionalCoords(in vec2 _uv) {
  return fract(_uv);
}

vec2 getIntegerCoords(in vec2 _uv) {
  return floor(_uv);
}

vec2 makeAnimations(in vec2 _uv) {
  _uv = (_uv - vec2(5.0)) * (abs(sin(uTime * 0.2)) * 5.0);
  _uv.x += uTime * 3.0;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  _uv *= 10.0;
  _uv = makeAnimations(-_uv);
  vec2 ipos = getIntegerCoords(_uv);
  vec2 fpos = getFractionalCoords(_uv);
  vec2 tile = truchetPattern(fpos, random(ipos));
  float maze = makeMaze(tile);
  color = vec3(maze);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}
