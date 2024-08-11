precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

const float base = 10.0; // Set the base to 2.0 initially

// Function to compute the Euler–Riemann zeta function
float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 1000; // Number of terms in the series for approximation

    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma);
        float log_n_base = log(float(n)) / log(base); // Convert n to the logarithm in the new base
        float angle = -t * log_n_base; // Adjust the angle calculation to use the new base
        sum += term * tan(angle); // Real part
    }

    return sum;
}

void main() {
    float scale = 100.0;
    float half_scale = scale * 0.5;
    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale; // Real part of s (horizontal axis)
    float t = vUv.x * scale - half_scale;    // Imaginary part of s (vertical axis)

    // Compute the zeta function value
    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    float normalizedZeta = 0.5 + 0.1 * zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedZeta * 3.14159));

    gl_FragColor = vec4(gradient2, 1.0);
}
