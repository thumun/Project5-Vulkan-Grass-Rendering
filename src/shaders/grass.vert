
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs

layout (location = 0) in vec4 in_v0;
layout (location = 1) in vec4 in_v1;
layout (location = 2) in vec4 in_v2;
layout (location = 3) in vec4 in_up;

layout (location = 0) out vec4 out_v0;
layout (location = 1) out vec4 out_v1;
layout (location = 2) out vec4 out_v2;
layout (location = 3) out vec4 out_up;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs

    // translates the other Bezier curve inputs to match
    // the correct orientation and position of the blade object.
    out_v0 = model * in_v0;
    out_v1 = model * in_v1;
    out_v2 = model * in_v2;
    out_up = model * in_up;

    // base pos of blade 
    gl_Position = out_v0;
}
