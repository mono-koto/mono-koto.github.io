#define PI 3.1415926535897932384626433832795

// The MIT License
// Copyright © 2017 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org

// Computes the analytic derivatives of a 2D Gradient Noise.
//
// All noise functions here:
//
// https://www.shadertoy.com/playlist/fXlXzf&from=0&num=12

// 0: integer hash
// 1: float hash (aliasing based)
#define METHOD 1

// 0: cubic
// 1: quintic
#define INTERPOLANT 1

#if METHOD==0
vec2 hash(in ivec2 p)  // this hash is not production ready, please
{                        // replace this by something better

    // 2D -> 1D
    ivec2 n = p.x * ivec2(3, 37) + p.y * ivec2(311, 113);

    // 1D hash by Hugo Elias
    n = (n << 13) ^ n;
    n = n * (n * n * 15731 + 789221) + 1376312589;
    return -1.0 + 2.0 * vec2(n & ivec2(0x0fffffff)) / float(0x0fffffff);
}
#else
vec2 hash(in vec2 x)   // this hash is not production ready, please
{                        // replace this by something better
    const vec2 k = vec2(0.3183099, 0.3678794);
    x = x * k + k.yx;
    return -1.0 + 2.0 * fract(16.0 * k * fract(x.x * x.y * (x.x + x.y)));
}
#endif

// return gradient noise (in x) and its derivatives (in yz)
vec3 noised(in vec2 p) {
    #if METHOD==0
    ivec2 i = ivec2(floor(p));
    #else
    vec2 i = floor(p);
    #endif
    vec2 f = fract(p);

    #if INTERPOLANT==1
    // quintic interpolation
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    vec2 du = 30.0 * f * f * (f * (f - 2.0) + 1.0);
    #else
    // cubic interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);
    vec2 du = 6.0 * f * (1.0 - f);
    #endif    

    #if METHOD==0
    vec2 ga = hash(i + ivec2(0, 0));
    vec2 gb = hash(i + ivec2(1, 0));
    vec2 gc = hash(i + ivec2(0, 1));
    vec2 gd = hash(i + ivec2(1, 1));
    #else
    vec2 ga = hash(i + vec2(0.0, 0.0));
    vec2 gb = hash(i + vec2(1.0, 0.0));
    vec2 gc = hash(i + vec2(0.0, 1.0));
    vec2 gd = hash(i + vec2(1.0, 1.0));
    #endif

    float va = dot(ga, f - vec2(0.0, 0.0));
    float vb = dot(gb, f - vec2(1.0, 0.0));
    float vc = dot(gc, f - vec2(0.0, 1.0));
    float vd = dot(gd, f - vec2(1.0, 1.0));

    return vec3(va + u.x * (vb - va) + u.y * (vc - va) + u.x * u.y * (va - vb - vc + vd),   // value
    ga + u.x * (gb - ga) + u.y * (gc - ga) + u.x * u.y * (ga - gb - gc + gd) +  // derivatives
        du * (u.yx * (va - vb - vc + vd) + vec2(vb, vc) - va));
}

vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

vec3 palette(in float t) {
    vec3 a = vec3(0.588, 0.658, 0.378);
    vec3 b = vec3(0.388, 0.408, -0.202);
    vec3 c = vec3(1.988, 0.771, 1.148);
    vec3 d = vec3(3.138, 1.118, -2.802);
    // return vec3(1.0, 1.0, 1.0);
    return palette(t, a, b, c, d);

}

vec3 palette2(in float t) {
    vec3 a = vec3(0.500, 0.500, 0.500);
    vec3 b = vec3(-0.452, 0.500, 0.500);
    vec3 c = vec3(1.000, 1.000, 1.000);
    vec3 d = vec3(0.000, 0.333, 0.667);
    return palette(t, a, b, c, d);
}

float plot(vec2 st, float pct) {
    return smoothstep(pct - 0.02, pct, st.y) -
        smoothstep(pct, pct + 0.02, st.y);
}

float rand(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(float p) {
    float fl = floor(p);
    float fc = fract(p);
    return mix(rand(fl), rand(fl + 1.0), fc);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    // vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    // float y = smoothstep(0.1, 0.9, uv.x);
    // float y = abs(fract(2. * uv.x) - 0.5);

    // float y = 2. * (1.0 - pow(abs(uv.x), 1.5)) - 1.;
    float y;

    for(float i = 0.; i < 10.; i++) {
        uv = fract(uv * 1.5) - .5;

        float t = iTime;

        float n = sin(t * length(noised(uv * 10. + i * 10.)));
        float d = length(uv) + n / 40.;
        d = sin(d * 8. - iTime * 1. + i * 2.) / 8.;
        d = abs(d);
        d = pow(0.01 / d, 2.0);

        vec3 col = palette2(length(uv0) + i * .4);

        finalColor += col * d;
    }

    // float pct = plot(uv, y);

    // finalColor = (1.0 - pct) * finalColor + pct * vec3(0.0, 1.0, 0.0);

    // for(float i = 0.; i < 10.0; i++) {

    //     uv = fract(uv * 1.5) - 0.5;

    //     float d = length(uv) * exp(-length(uv0));

    //     vec3 col = palette2(length(uv0) + i * .4);

    //     d = sin(d * 8. + iTime * 1.) / 8.;
    //     d = abs(d);
    //     d = pow(0.005 / d, 2.0);
    //     finalColor += col * d;
    // }

    // // Output to screen
    fragColor = vec4(finalColor, 1.0);
}

// // -----------------------------------------------

// void mainImage(out vec4 fragColor, in vec2 fragCoord) {
//   vec2 p = (2.0 * fragCoord - iResolution.xy) / iResolution.y;

//   p.x += iTime * 0.1;
//   vec3 n = noised(8.0 * p);

//   // vec3 col = 0.5 + 0.5 * ((p.x > 0.0) ? n.yzx : n.xxx);
//   vec3 col = 0.5 + 0.5 * n.yzx;

//   fragColor = vec4(col, 1.0);
// }