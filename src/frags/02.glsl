vec3 palette(in float t) {
    vec3 a = vec3(0.588, 0.658, 0.378);
    vec3 b = vec3(0.388, 0.408, -0.202);
    vec3 c = vec3(1.988, 0.771, 1.148);
    vec3 d = vec3(3.138, 1.118, -2.802);
    return vec3(1.0, 1.0, 1.0);
    return a + b * cos(6.28318 * (c * t + d));
}

float ndot(vec2 a, vec2 b) {
    return a.x * b.x - a.y * b.y;
}
float sdRhombus(in vec2 p, in vec2 b) {
    p = abs(p);
    float h = clamp(ndot(b - 2.0 * p, b) / dot(b, b), -1.0, 1.0);
    float d = length(p - 0.5 * b * vec2(1.0 - h, 1.0 + h));
    return d * sign(p.x * b.y + p.y * b.x - b.x * b.y);
}

float sdBox(in vec2 p, in vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 finalColor = vec3(0.0);
    // uv = smoothstep(-2.0, 2.0, uv);
    // uv = fract(uv * 10. + 0.2) - 0.2; 

    for(float i = 0.; i < 2.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = sdRhombus(uv, vec2(0.1 * iTime));

        vec3 col = palette(length(uv) + 0.5 * iTime);
        if(mod(i, 2.0) == 0.0) {
            // d = sdBox(uv, vec2(0.1 * iTime));
            col = vec3(1., 0., 0.);
        }

        d = sin(d * 6.) / 3.;
        d = abs(d);
        d = pow(0.01 / d, 2.0);
        finalColor += col * d;
    }

    fragColor = vec4(finalColor, 1.0);
}
