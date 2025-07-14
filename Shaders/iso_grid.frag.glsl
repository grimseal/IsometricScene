#version 450 core

in vec2 screenUV;
in vec2 ndc;
out vec4 FragColor;

uniform mat4 inverseProjectionMatrix;
uniform vec2 gridSize;
uniform vec4 inGridColor;
uniform vec4 outGridColor;

const float cellWidth = 48.0;
const float cellHeight = 24.0;
const float lineThickness = 1.0 / cellWidth;
const float toGridWidth = 1.0 / (cellWidth / 2);
const float toGridHeight = 1.0 / (cellHeight / 2);

vec2 getWorldPos() {
    return (inverseProjectionMatrix * vec4(ndc, 0.0, 1.0)).xy;
}

vec2 worldToGrid(vec2 worldPos) {
    float x = (worldPos.x * toGridWidth + worldPos.y * toGridHeight) * 0.5;
    float y = (worldPos.y * toGridHeight - worldPos.x * toGridWidth) * 0.5;
    return vec2(x, y);
}

float inGrid(vec2 gridPos, vec2 gridSize) {
    vec2 inside = step(vec2(0.0), gridPos) * step(gridPos, gridSize - vec2(1e-3));
    return inside.x * inside.y;
}

void main() {
    vec2 gridPos = worldToGrid(getWorldPos());
    vec2 distToLine = abs(fract(gridPos + 0.5) - 0.5);
    float lineX = step(lineThickness, distToLine.x);
    float lineY = step(lineThickness, distToLine.y);
    float gridLine = 1.0 - min(lineX, lineY);
    float insideMask = inGrid(gridPos, gridSize);
    vec3 baseColor = mix(outGridColor, inGridColor, insideMask).xyz;
    vec3 finalColor = baseColor * (.5 + gridLine * .5);
    FragColor = vec4(finalColor, 1);
}