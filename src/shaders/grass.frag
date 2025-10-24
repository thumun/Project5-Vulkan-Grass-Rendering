#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs

layout(location = 0) in vec3 in_normal;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

    //vec3 lighPos = normalize(vec3(0.0, 10.0, 0.0));
    //float intensity = clamp(dot(normalize(in_normal), lighPos), 0.0, 1.0);

    vec3 diffuseColor = vec3(0.43, 0.61, 0.06);
    // add ambient?
    //vec3 color = diffuseColor * intensity;

    outColor = vec4(diffuseColor, 1.0);
}
