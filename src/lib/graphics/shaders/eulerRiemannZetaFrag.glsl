precision highp float;
varying vec2 vUv;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

const float CRITICAL_LINE = 0.5; // The real part of s on the critical line
const float ZERO_LINE = 0.0; // The real part of s at 0
const float ONE_LINE = 1.0; // The real part of s at 1

// Function to compute the Euler–Riemann zeta function
float zeta(float sigma, float t) {
    float sum = 0.0;
    const int N = 200; // Number of terms in the series for approximation

    for (int n = 1; n <= N; ++n) {
        float term = pow(float(n), -sigma);
        float angle = -t * log(float(n));
        sum += term * tan(angle); // Tangent part
    }

    return sum;
}

void main() {
    float scale = 100.0;
    float half_scale = scale * 0.5;
    float half_scale_height = scale * 0.5;
    // Map the fragment coordinates to the complex plane
    float sigma = vUv.y * scale - half_scale_height; // Real part of s
    float t = vUv.x * scale - half_scale;    // Imaginary part of s

    // Compute the zeta function value
    float zetaValue = zeta(sigma, t);

    // Normalize zetaValue to map to color range
    float normalizedZeta = 0.5 + 0.1 * zetaValue; // Adjust scaling factor for better contrast

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedZeta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedZeta * 3.14159));

    // Draw the critical strip
    float lineThickness = 0.0002; // Thickness of the line
    float criticalLinePosition = (CRITICAL_LINE + 10.0) / 20.0; // Normalize the critical line position
    float zeroLinePosition = (ZERO_LINE + 10.0) / 20.0; // Normalize the zero line position
    float oneLinePosition = (ONE_LINE + 10.0) / 20.0; // Normalize the one line position

    // Highlight the critical strip
    if (abs(vUv.y - criticalLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(1.0, 0.0, 0.0), 0.7); // Red line for the critical strip
    }

    // Highlight the zero line
    if (abs(vUv.y - zeroLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for zero
    }

    // Highlight the one line
    if (abs(vUv.y - oneLinePosition) < lineThickness) {
        gradient2 = mix(color3, vec3(0.0, 0.0, 0.0), 0.7); // Black line for one
    }

    gl_FragColor = vec4(gradient2, 1.0);
}
