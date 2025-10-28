Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Neha Thumu
  * [LinkedIn](https://www.linkedin.com/in/neha-thumu/)
* Tested on: Windows 11 Pro, i9-13900H @ 2.60GHz 32GB, Nvidia GeForce RTX 4070

(add gif)

## Project Details

This project is based on the following paper [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf) and was built using the Vulkan API. We use various forces to simulate the movement of the grass and employ culling methods along with tesselation to optimize the process.

### Rendering the Grass
(add gif of grass with no forces) 

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
#### Recovery
(add gif) 


#### Gravity 
(add gif)

The gravitational force is a combination of environmental gravity annd front gravity. Environmental gravity is a global force that affects all the blades in the scene. In this case, it is a downwards pull of a constant value. 

<img width="534" height="91" alt="image" src="https://github.com/user-attachments/assets/05b32bce-4407-48a5-bd7d-c68f1e1a8af4" />

On the other hand, front gravity is blade specific-which means it uses the front direction of the blade in combination with the enivornmental gravity.

<img width="166" height="68" alt="image" src="https://github.com/user-attachments/assets/706a186c-ffcd-43b6-80d7-9a6c9e637bcb" />

<img width="172" height="45" alt="image" src="https://github.com/user-attachments/assets/f4d56cdd-0516-40f8-88fd-bf7e08500f9f" />

(add equations) 

#### Wind
(add gif)

<img width="516" height="172" alt="image" src="https://github.com/user-attachments/assets/2b4f67fa-281e-47ec-8117-c9ac037ba392" />

<img width="300" height="44" alt="image" src="https://github.com/user-attachments/assets/792eb4ba-7b5b-4ca8-8195-532a46a227c3" />

### Culling 
#### Occlusion
(add gif)

#### View-Frustrum
(add gif)

#### Distance 
(add gif)

### Level of Detail 
(add gif)

### GUI
(add gif)

## Performance Analysis 

## Resources Used 
- add shadertoy used for noise
- add research paper ; diagram also from here 
- recitation
- opengl tutorial for tessalation 
