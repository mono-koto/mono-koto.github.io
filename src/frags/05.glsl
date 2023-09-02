#define PI 3.1415926535897932384626433832795

#define BG_COLOR vec3(0.1, 0.1, 0.1)

vec2 quantize(vec2 inp, vec2 period) {
    return floor((inp + period / 2.) / period) * period;
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    float t = iTime + 1020.;
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 finalColor = BG_COLOR;

    float d = 0.0;

    for(float i = 0.; i < 20.; i++) {
        uv.y += i * t / 3000.0;

        vec2 qvec = vec2(0.0005 * (i + 1.), 0.0005 * (i + 1.));
        d = rand(quantize(uv + t / (80. + 20. * sin(t / 100.)), qvec));
        float d2 = rand(quantize(uv + t / (80. + 20. * sin(t / 100.)), qvec));
        float d3 = rand(quantize(uv + t / 100., qvec));

        d = smoothstep(0.86 + 0.1 * sin(t * 0.1), 1., d);
        d2 = smoothstep(0.86 + 0.1 * cos(t * 0.3), 1., d2);
        d3 = smoothstep(0.86 + 0.1 * sin(t * 0.5 + PI), 1., d3);

        finalColor += vec3(d, d2, d3) / 10.;
    }

    fragColor = vec4(finalColor, 1.0);
}
