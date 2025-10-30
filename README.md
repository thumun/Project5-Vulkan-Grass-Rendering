Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Neha Thumu
  * [LinkedIn](https://www.linkedin.com/in/neha-thumu/)
* Tested on: Windows 11 Pro, i9-13900H @ 2.60GHz 32GB, Nvidia GeForce RTX 4070

![main](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/grassmain.gif?raw=true)

## Project Details

This project is based on the following paper [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf) and was built using the Vulkan API. We use various forces to simulate the movement of the grass and employ culling methods along with tesselation to optimize the process.

### Rendering the Grass
![still](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/stillgrass.gif?raw=true)

The grass in this project is represented as bezier curves composed of three control points: v0, v1, and v2. 
- v0: the position of the grass blade on the geometry (or ground)
- v1: a curve guide that is always above v0 (with respect to the grass blade's up vector)
- v2: a guide for simulating the forces as well as the tip of the blade

The blades also have the following properties: 
- Up: the blade's up vector, which corresponds to the normal of the geometry that the grass blade resides on at v0
- Orientation: the orientation of the grass blade's face
- Height: the height of the grass blade
- Width: the width of the grass blade's face
- Stiffness coefficient: the stiffness of our grass blade, which will affect the force computations on our blade  
![bladeDiagram](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/blade_model.jpg?raw=true)

We use the above data to construct the individual grass blades via De Casteljau's algorithm as well as simulate the movement of the blades.

### Simulating Forces 
![forces](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/forces.gif?raw=true)

#### Recovery
The recovery force is a counterforce against the applied forces of gravity and wind. This logic follows Hooke's Law. We take the difference of the initial position of the grass blade and the current position and apply the stiffness coefficient to create this force: 

<img width="187" height="45" alt="image" src="https://github.com/user-attachments/assets/81619755-047e-4fb4-a1ed-f13e7d57440a" />

#### Gravity 
The gravitational force is a combination of environmental gravity annd front gravity. Environmental gravity is a global force that affects all the blades in the scene. In this case, it is a downwards pull of a constant value. 

<img width="534" height="91" alt="image" src="https://github.com/user-attachments/assets/05b32bce-4407-48a5-bd7d-c68f1e1a8af4" />

On the other hand, front gravity is blade specific-which means it uses the front direction of the blade in combination with the enivornmental gravity.

<img width="166" height="68" alt="image" src="https://github.com/user-attachments/assets/706a186c-ffcd-43b6-80d7-9a6c9e637bcb" />

<img width="172" height="45" alt="image" src="https://github.com/user-attachments/assets/f4d56cdd-0516-40f8-88fd-bf7e08500f9f" />

#### Wind
The wind utilizes an analytic function to control the direction of the wind force. In this case, the function utilizes noise in combination with sinusodial functions to mimic a breeze. We then take this function to find the directional alignment of the wind. We also calculate a height ratio which indicated the "straightness of the blade with respect to the up vector of the blade" - this is used to apply a stronger affect on blades that are at the resting/initial position.

<img width="516" height="172" alt="image" src="https://github.com/user-attachments/assets/2b4f67fa-281e-47ec-8117-c9ac037ba392" />

Then we combine the forces together to create our total wind force.

<img width="300" height="44" alt="image" src="https://github.com/user-attachments/assets/792eb4ba-7b5b-4ca8-8195-532a46a227c3" />

### Culling 
#### Orientation
![orientation](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/orientation.gif?raw=true)

Orientation based culling allows for grass blades that are parallel to the view direction of the camera to be optimized away. As these blades would not be visible anyways due to the blades not having a thickness. We accomplish this by taking the dot product of the view direction and the direction of the blade and comparing it with a threshold value. 

<img width="388" height="50" alt="image" src="https://github.com/user-attachments/assets/e559f222-5803-4cf8-92f2-8716abfae15f" />

#### View-Frustrum
![viewfrustrum](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/viewfrustrum.gif?raw=true)

View-Frustrum culling takes care of blades that are outside of the camera's view-frustrum. We check to make sure that three points on the blade: v0, m (the midpoint of a curve composed of the three points), and v2 are all in the frustrum otherwise the blade is culled.

<img width="234" height="58" alt="image" src="https://github.com/user-attachments/assets/13faf523-f387-4c9d-8a63-5dedd3c17db7" />

We  want to ensure that all of our points are in NDC space prior to comparing with our homogenous coordinate, h. There is also an arbitrary threshold, t, that is taken into account when comparing the points with the frustrum.

<img width="447" height="115" alt="image" src="https://github.com/user-attachments/assets/1f513433-a586-4419-939c-c193ec0d36b7" />

In the gif above, the culling is very subtle as it culls blades that are outside the camera's frustrum. The culling can be seen on the edges of the grass plane.

#### Distance 
![dist](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/distanceculling.gif?raw=true)

Distance culling is where we cull blades based on their distance from the camera. In this implementation we use the distance from the camera to a blade (dproj), a maximum distance (where all grass beyond this distance will be culled), and buckets that our blades are sorted into such that the blades in the farther buckets are culled.
<img width="316" height="38" alt="image" src="https://github.com/user-attachments/assets/3b6a8327-4144-4f5e-9df8-6b318506f997" />

<img width="388" height="67" alt="image" src="https://github.com/user-attachments/assets/f212054e-02a8-409f-ac43-4b030cac7abe" />

### Level of Detail
![lod](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/tesselation.gif?raw=true)

A tesselation control shader is used to provide varying amounts of detail for our grass blades depending on how far they are from our camera. The blades closest to our camera have more verticies/detail while those farther away are simplified - this can be seen more clearly in the above gif. This is done via a smoothstep function in order to smoothly transition from varying levels of detail rather than have clear patches of grass of different verticies.

## Performance Analysis 

Number of Blades vs FPS | Culling Methods vs FPS |
:-------------------------:|:-------------------------:|
![bladevsfps](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/numbladesvsfps.png?raw=true) | ![cullingmethods](https://github.com/thumun/Project5-Vulkan-Grass-Rendering/blob/main/img/cullingmethods.png?raw=true) |

Here is a table version of the data presented in the charts above:

Number of Blades | None | Orientation | View-Frustrum | Distance | All |
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
2^10 | 624.8 | 528.3 | 626.6 | 223.3 | 248.8 |
2^12 | 594.6 | 596.6 | 633.4 | 419.7 | 512.2 |
2^14 | 504.4 |	605.6 |	572.2 |	590.3 |	604.3 |
2^16 | 287.1 |	565.5 |	412.9 |	619.7 |	622.9 |
2^18 | 98.4 |	311.3 |	151.7 |	407.5 |	562.5 |
2^20 | 29.9 |	105.1 |	44.2 |	105.3 |	421.0 |

The first chart depicts the renderer's performance as the number of blades increases while having no additional optimization methods (culling). As the blade count increases, the FPS gets lower as expected. The renderer is able to effectively simulate the grass until there is 2^16 blades of grass in the scene-at this point, the FPS drops to approximately 287 - which is still workable. The worse frame rates can be seen beyond this point. 

The second chart depicts the effect of the various culling methods on the FPS as the number of blades increases. There is a general trend (as expected) of the FPS going down for all the methods as the number of blades increases. However, it is worth noting that each of the culling methods result in a better FPS than the base renderer (however small that increase may be). It is interesting to look at how for the case of all of the culling methods in tandem and distance, there is a worse FPS than having no culling at all. I imagine that may be due to having extra computation that may not be necessary for a lower number of blades. It is also curious that orientation seems to be the best method in general while view-frustrum improves as the number of blades increases. The most optimal number of blades for each of the methods appears to be 2^14 or 2^16.

## Resources Used 
- ![Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf) : the research paper that this project is based on and the diagrams above are sourced from here 
- 5650 class material (recitation)
- ![Noise Shadertoy](https://www.shadertoy.com/view/4dS3Wd)
- ![OpenGL tutorial for tessalation](https://learnopengl.com/Guest-Articles/2021/Tessellation/Tessellation)
