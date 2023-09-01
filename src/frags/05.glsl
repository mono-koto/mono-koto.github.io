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

#define BG_COLOR vec3(0.1, 0.1, 0.1)
#define FG_COLOR vec3(0.905882353, 0.898039216, 0.905882353)

// vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d) {
//     return a + b * cos(6.28318 * (c * t + d));
// }

vec2 quantize(vec2 inp, vec2 period) {
    return floor((inp + period / 2.) / period) * period;
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    float t = iTime + 100.;
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 finalColor = BG_COLOR;

    float d = 0.0;

    float p = 1.;
    float q = 1.;

    for(float i = 0.; i < 3.; i++) {
        uv.y += t / 10.0;

        d = rand(quantize(uv - 0.02 * sin(i + 0.3 * t), vec2(0.1 * i, 0.1 * i)));
        float d2 = rand(quantize(uv + 0.03 * sin(i + 0.1 * t), vec2(0.1 * i, 0.1 * i)));
        float d3 = rand(quantize(uv - 0.01 * sin(i + 2. + 0.1 * t), vec2(0.1 * i, 0.1 * i)));

        d = smoothstep(0.0, 0.8, d);
        d2 = smoothstep(0.0, 0.8, d2);
        d3 = smoothstep(0.0, 0.8, d3);

        finalColor += vec3(d, d2, d3) / 2.;
    }

    fragColor = vec4(finalColor, 1.0);
}
