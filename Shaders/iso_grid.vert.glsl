#version 450 core

in vec2 position;
in vec2 uv;
uniform mat4 projectionMatrix;
out vec2 texCoord;

void main() {
   	gl_Position = vec4(vertexPosition, 0, 1.0);
	texCoord = vertexUV;
}