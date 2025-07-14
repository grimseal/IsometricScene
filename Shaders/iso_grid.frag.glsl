#version 450 core

in vec2 vUV;
out vec4 FragColor;

uniform float scale = 40.0;  // Размер плитки
uniform float lineWidth = 1.0;
uniform vec3 gridColor = vec3(0.2, 0.2, 0.2);
uniform vec3 backgroundColor = vec3(1.0);

float drawLine(vec2 uv, vec2 dir, float spacing) {
    float line = abs(dot(uv, dir));
    float modLine = mod(line, spacing);
    return smoothstep(lineWidth, 0.0, modLine);
}

void main() {
    vec2 uv = vUV * scale;

    // Изометрическая проекция: направляющие под 30° и 150°
    vec2 dir1 = normalize(vec2(1.0, sqrt(3.0)));   // ≈ 60°
    vec2 dir2 = normalize(vec2(1.0, -sqrt(3.0)));  // ≈ -60°

    float line1 = drawLine(uv, dir1, scale);
    float line2 = drawLine(uv, dir2, scale);
    float line3 = drawLine(uv, vec2(0.0, 1.0), scale); // вертикальные

    float grid = max(max(line1, line2), line3);

    FragColor = vec4(mix(backgroundColor, gridColor, grid), 1.0);
}