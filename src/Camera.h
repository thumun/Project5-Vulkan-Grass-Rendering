
#pragma once

#include <glm/glm.hpp>
#include "Device.h"

struct CameraBufferObject {
  glm::mat4 viewMatrix;
  glm::mat4 projectionMatrix;
  uint32_t tessellationLODEnabled = 0;
  uint32_t renderSettingEnableRecovery = 1;
  float renderSettingEnableGravity = 9.8;
  uint32_t renderSettingEnableWind = 1;
  float orientationCullingThreshold = 0.9f; // zero means disabled
  uint32_t viewFrustumCullingEnabled = 0;
  float distanceCullingThreshold = 15.0f; // zero means disabled
};

class Camera {
private:
    Device* device;
    
    CameraBufferObject cameraBufferObject;
    
    VkBuffer buffer;
    VkDeviceMemory bufferMemory;

    void* mappedData;

    float r, theta, phi;

public:
    Camera(Device* device, float aspectRatio);
    ~Camera();

    VkBuffer GetBuffer() const;
    
    void UpdateOrbit(float deltaX, float deltaY, float deltaZ);
};
