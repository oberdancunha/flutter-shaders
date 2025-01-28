// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 computeFinalNoise(in vec3 _a0, in vec2 _x0, in vec2 _x1, in vec2 _x2, in vec3 _h) {
  vec3 gColor = vec3(0.0);
  gColor.x = (_a0.x * _x0.x) + (_h.x * _x0.y);
  gColor.yz = (_a0.yz * vec2(_x1.x, _x2.x)) + (_h.yz * vec2(_x1.y, _x2.y));

  return gColor;
}

vec3 normalizeGradients(in vec3 _m, in vec3 _a0, in vec3 _h) {
  _m *= 1.79284291400159 - 0.85373472095314 * ((_a0 * _a0) + (_h * _h));

  return _m;

}

vec3 mod289(in vec3 _x) { return _x - floor(_x * (1.0 / 289.0)) * 289.0; }
vec3 permute(in vec3 _x) { return mod289(((_x * 34.0) + 1.0) * _x); }
vec2 mod289(in vec2 _x) { return _x - floor(_x * (1.0 / 289.0)) * 289.0; }

vec3 avoidTruncationEffects(in vec2 _i, in vec2 _i1) {
  vec2 i = mod289(_i);
  vec3 p = permute(
    permute(
      i.y + vec3(
        0.0, 
        _i1.y, 
        1.0
      )
    ) + i.x + vec3(
      0.0,
      _i1.x,
      1.0
    )
  );

  return p;
}

vec2 getUpperCorner() {
  return vec2(0.0, 1.0);
}

vec2 getLowerCorner() {
  return vec2(1.0, 0.0);
}

bool isLowerCorner(in vec2 _x0) {
  return _x0.x > _x0.y;
}

vec2 getFirstCorner(in vec2 _v, in vec2 _i, const vec4 _C) {
  vec2 x0 = _v - _i + dot(_i, _C.xx);

  return x0;
}

vec4 precomputeValuesForSkewedTriangularGrid() {
  return vec4(
    0.211324865405187,
    0.366025403784439,
    -0.577350269189626,
    0.024390243902439
  );
}

float snoise(in vec2 _v) {
  const vec4 C = precomputeValuesForSkewedTriangularGrid();
  vec2 i = floor(_v + dot(_v, C.yy));
  vec2 x0 = getFirstCorner(_v, i, C);
  
  // Other two corners (x1, x2)
  vec2 i1 = vec2(0.0);
  i1 = isLowerCorner(x0) ? getLowerCorner() : getUpperCorner();
  vec2 x1 = x0.xy + C.xx - i1;
  vec2 x2 = x0.xy + C.zz;
  vec3 p = avoidTruncationEffects(i, i1);

  vec3 m = max(
    0.5 - vec3(
      dot(x0, x0),
      dot(x1, x1),
      dot(x2, x2)
    ), 
    0.0
  );
  m = m * m;
  m = m * m;

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  m = normalizeGradients(m, a0, h);
  vec3 g = computeFinalNoise(a0, x0, x1, x2, h);

  return 130.0 * dot(m, g);
}

vec2 scaleSpaceInOrderToSeeFunction(in vec2 _uv) {
  _uv *= 10.0;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;
  vec3 color = vec3(0.0);
  _uv = scaleSpaceInOrderToSeeFunction(_uv);
  color = vec3((snoise(_uv) * 0.5) + 0.5);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}