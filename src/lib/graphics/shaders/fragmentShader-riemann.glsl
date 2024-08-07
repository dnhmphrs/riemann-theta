precision mediump float; // Use medium precision for balance between quality and performance
varying vec2 vUv; // Varying vector for texture coordinates
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec2 mouse;

// Function to create a dynamic Riemann matrix based on mouse input
mat3 createDynamicOmega(vec2 mouse) {
    mouse.x *= 0.6;
    mouse.y *= 0.6;
    return mat3(
        1.0 + 0.5 * sin(mouse.x * 3.14159), 0.5 * cos(mouse.y * 3.14159), 0.2 * sin(mouse.x),
        0.5 * cos(mouse.x), 1.0 + 0.5 * cos(mouse.y * 3.14159), 0.1 * sin(mouse.x * 3.14159),
        0.2 * sin(mouse.x), 0.1 * cos(mouse.x), 1.0 + 0.5 * sin(mouse.y * 3.14159)
    );
}

const int N = 2; // Number of terms in the series

// Function to compute the real and imaginary parts of the Riemann theta function
vec2 riemannThetaParts(vec3 z, mat3 Omega) {
    float realSum = 0.0;
    float imagSum = 0.0;

    // Iterate over the range of n values for 3 dimensions
    for (int n1 = -N; n1 <= N; ++n1) {
        for (int n2 = -N; n2 <= N; ++n2) {
            for (int n3 = -N; n3 <= N; ++n3) {
                vec3 n = vec3(float(n1), float(n2), float(n3));

                // Compute n^T * Omega * n
                float nt_Omega_n = dot(n, Omega * n);

                // Compute 2 * n^T * z
                float nt_z = 2.0 * dot(n, z);

                // Compute the exponential term
                float exponent = 3.14159 * (nt_Omega_n + nt_z);

                // Calculate real and imaginary parts
                float realPart = cos(exponent); // Real part
                float imagPart = sin(exponent); // Imaginary part

                realSum += realPart;
                imagSum += imagPart;
            }
        }
    }

    return vec2(realSum, imagSum);
}

void main() {
    // Map the fragment coordinates to the complex plane
    float x = vUv.x * 10.0 - 5.0;
    float y = vUv.y * 10.0 - 5.0;

    // Create a dynamic Riemann matrix based on mouse input
    mat3 OmegaDynamic = createDynamicOmega(mouse);

    // Construct a 3D vector for the z variable
    vec3 z = vec3(x, y, 2.0); // Static third component

    // Calculate the real and imaginary parts of the Riemann theta function at z
    vec2 thetaParts = riemannThetaParts(z, OmegaDynamic);

    // Calculate the absolute value
    float thetaAbs = length(thetaParts);

    // Normalize thetaAbs to map to color range
    float normalizedTheta = mod(log(1.0 + thetaAbs) * 0.2, 1.0);

    // Create gradients for visualization
    vec3 gradient1 = mix(color1, color2, normalizedTheta);
    vec3 gradient2 = mix(color3, gradient1, 0.5 + 0.5 * sin(normalizedTheta));

    gl_FragColor = vec4(gradient2, 1.0);
}
