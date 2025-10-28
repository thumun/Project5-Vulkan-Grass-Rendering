#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
    uint tessellationLODEnabled;
    uint renderSettingEnableRecovery;
    float renderSettingEnableGravity;
    uint renderSettingEnableWind;
    float orientationCullingThreshold; // zero means disabled
    uint viewFrustumCullingEnabled;
    float distanceCullingThreshold; // zero means disabled
} camera;

// TODO: Declare tessellation control shader inputs and outputs

layout (location = 0) in vec4 in_v0[];
layout (location = 1) in vec4 in_v1[];
layout (location = 2) in vec4 in_v2[];
layout (location = 3) in vec4 in_up[];

layout (location = 0) out vec4 out_v0[];
layout (location = 1) out vec4 out_v1[];
layout (location = 2) out vec4 out_v2[];
layout (location = 3) out vec4 out_up[];

in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

out gl_PerVertex {
    vec4 gl_Position;
} gl_out[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs
    out_v0[gl_InvocationID] = in_v0[gl_InvocationID];
    out_v1[gl_InvocationID] = in_v1[gl_InvocationID];
    out_v2[gl_InvocationID] = in_v2[gl_InvocationID];
    out_up[gl_InvocationID] = in_up[gl_InvocationID];

	// TODO: Set level of tesselation
    float tessLevel = 5.0;
    if(camera.tessellationLODEnabled > 0) {
        // Compute distance-based tessellation level
        vec3 v0 = in_v0[gl_InvocationID].xyz;
        vec3 camPos = inverse(camera.view)[3].xyz;
        float dist = length(v0 - camPos);

        tessLevel = dist < 10.0 ? 18.0 :
                    dist < 20.0 ? 9.0 :
                    5.0;
    }

    gl_TessLevelInner[0] = tessLevel;
    gl_TessLevelInner[1] = tessLevel;
    gl_TessLevelOuter[0] = tessLevel;
    gl_TessLevelOuter[1] = tessLevel;
    gl_TessLevelOuter[2] = tessLevel;
    gl_TessLevelOuter[3] = tessLevel;
}
