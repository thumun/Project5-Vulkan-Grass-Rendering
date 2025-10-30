
#pragma once

#include <glm/glm.hpp>
#include "Device.h"

struct CameraBufferObject {
  glm::mat4 viewMatrix;
  glm::mat4 projectionMatrix;
  uint32_t tessellationLODEnabled = 1;
  uint32_t renderSettingEnableRecovery = 1;
  float renderSettingEnableGravity = 9.8f;
  uint32_t renderSettingEnableWind = 1;
  // 0 to disable the below
  float orientationCullingThreshold = 0.9f;
  float viewFrustumCullingEnabled = 0.2f;
  float distanceCullingThreshold = 15.0f;
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
