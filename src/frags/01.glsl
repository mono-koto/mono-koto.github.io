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

// void mainImage(out vec4 fragColor, in vec2 fragCoord) {
//     vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
//     vec2 uv0 = uv;
//     vec3 finalColor = vec3(0.0);

//     // for (float i = 0.; i < 1.0; i++) {

//     uv = fract(uv * 5.) - 0.1;
//     uv = smoothstep(0.1, 0.9, uv);
//     uv = fract(uv * 4.);// - sin(iTime * 0.0001) * 0.5;

//     float d = length(uv);// * exp(-length(uv0));

//     vec3 col = palette(length(uv));

//     d = sin(d * 8. /*+ iTime * 1.*/) / 8.;
//         // d = abs(d);
//     d = pow(0.015 / d, 2.0);
//     finalColor += col * d;
//     // }

//     // Output to screen
//     fragColor = vec4(finalColor, 1.0);
// }

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;  
//     vec2 uv0 = uv;
//     vec3 finalColor = vec3(0.0);

//     uv = fract(uv );
//     float len = abs(sin(length(uv) * 10.));

//     // float d = length(uv * sin(iTime * 0.5));
//     float d = 1.; //length(uv);

//     // vec3 col = palette(length(uv0));
//     vec3 col = vec3(len, 0.0, 0.0);

//     // uv = fract(uv + 1.);

//     // d = sin(d * 8. + iTime * 1.) / 8.;
//     // d = sin(d * 8.) / 8.;
//     // d = abs(d);
//     // d = pow(0.03 / d, 2.0);
//     // d = 0.03 / d;
//     finalColor += col * d;

//     // Output to screen
//     fragColor = vec4(finalColor, 1.0);
// }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for(float i = 0.; i < 10.0; i++) {

        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette2(length(uv0) + i * .4);

        d = sin(d * 8. + iTime * 1.) / 8.;
        d = abs(d);
        d = pow(0.005 / d, 2.0);
        finalColor += col * d;
    }

    // Output to screen
    fragColor = vec4(finalColor, 1.0);
}

// void main(void) {
    // mainImage(gl_FragColor, gl_FragCoord.xy);
// }
