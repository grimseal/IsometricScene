package graphics;

import kha.graphics4.*;

typedef Shader = {
	var vertexShader:VertexShader;
	var fragmentShader:FragmentShader;
	var ?geometryShader:GeometryShader;
	var ?tessellationControlShader:TessellationControlShader;
	var ?tessellationEvaluationShader:TessellationEvaluationShader;
}
