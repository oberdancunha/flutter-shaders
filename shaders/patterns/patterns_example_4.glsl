// https://thebookofshaders.com/09/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define PI 3.14159265358979323846

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec2 rotate2D(in vec2 _uv, in float _angle) {
  _uv -= 0.5;
  _uv = mat2(
    cos(_angle),
    -sin(_angle),
    sin(_angle),
    cos(_angle)
  ) * _uv;
  _uv *= 0.5;

  return _uv;
}

float getAngleAccordingIndex(in float index) {
  if (index == 1.0) {
    return PI * 0.5;
  }
  if (index == 2.0) {
    return PI * -0.5;
  }
  if (index == 3.0) {
    return PI;
  }

  return 0.0;
}

vec2 rotateEachCellAccordingIndex(in vec2 _uv, in float _index) {
  float angle = getAngleAccordingIndex(_index);
  
  return rotate2D(_uv, angle);
}

float checkEvenOrOdd(in float _value) {
  // return 0 is even
  // return 1 is odd: move the line or column
  return step(1.0, mod(_value, 2.0));
}

float giveEachCellIndexAccordingPosition(in vec2 _uv) {
  float index = 0.0;
  index += checkEvenOrOdd(_uv.x);
  index += checkEvenOrOdd(_uv.y) * 2.0;

    //      |
    //  2   |   3
    //      |
    //--------------
    //      |
    //  0   |   1
    //      |

  return index;
}

vec2 rotateTilePattern(in vec2 _uv) {
  //  Scale the coordinate system by 2x2
  _uv *= 2.0;

  float index = giveEachCellIndexAccordingPosition(_uv);

  // Make each cell between 0.0 - 1.0
  _uv = fract(_uv);
  
  _uv = rotateEachCellAccordingIndex(_uv, index);

  return _uv;
}

vec2 tile(in vec2 _uv, in float _zoom) {
  _uv *= _zoom;
   
   return fract(_uv);
}

vec2 invertBrick(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  _uv = invertBrick(_uv);
  _uv = tile(_uv, 3.0);
  _uv = rotateTilePattern(_uv);
  color = vec3(step(_uv.x, _uv.y));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}