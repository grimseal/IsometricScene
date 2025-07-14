#version 450 core

in vec2 vertexPosition;
in vec2 vertexUV;
out vec2 screenUV;
out vec2 ndc;

void main() {
   	gl_Position = vec4(vertexPosition, 0, 1.0);
	screenUV = vertexUV;
	ndc = vertexUV * 2.0 - 1.0;
    ndc.y *= -1.0;
}