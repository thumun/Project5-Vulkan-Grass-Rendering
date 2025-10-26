#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs

layout(location = 0) in vec2 in_uv;
layout(location = 1) in vec3 in_pos;
layout(location = 2) in vec3 in_normal;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

    vec3 lightPos = normalize(vec3(0.0, 5.0, 0.0));
    float intensity = clamp(dot(normalize(in_normal), normalize(in_pos - lightPos)), 0.0, 1.0);
    
    vec3 top = vec3(0.82, 0.859, 0.537);
    vec3 bottom = vec3(0.23, 0.361, 0.141);
    vec3 diffuseColor = vec3(bottom + in_pos.y * (top - bottom));

    float ambient = 0.2;

    vec3 color = diffuseColor * (ambient + intensity);

    outColor = vec4(color, 1.0);
    
}
