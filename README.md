
# It is a lightweight 2D game engine (written on Object Pascal and compilled in Lazarus). 
 
# Killer features: 
- thanks to the use of special structures like CSR (Compressed Sparse Row), editing even in software mode becomes incredibly fast (the complexity of the calculation depends only on the number of selected points and is almost independent of the number of all existing points on the scene);
- thanks to the "dirty rectangles" technology, scrolling of background objects occurs almost very quickly, which allows for the rendering of very large sprites (more than 30kx30k pixels) as background objects;
- using multi-threaded processing in conjunction with SIMD optimizations, it is possible to achieve quite decent speed even in software rendering mode.

# Brief description

Supported OS: currently only Windows.

Rendering type: software (OpenGL is used only for outputting the final frame, but shader support is already implemented).

Main modules:
01. Fast_AnimK      : animation (particles,physics,hair,fluid effects etc.)
02. Fast_GL         : initializing GLSL shaders
03. Fast_Graphics   : rendering of primitives (like a line, rectangle,circle), filters, blitters, CSR-sprites processing etc.
04. Fast_UI         : working with UI/UX elements
05. Fast_Scene_Tree : scene object manager
06. Fast_SIMD       : some SIMD powered routines
07. Fast_Threads    : working with threads (implementations of multi-threaded variants of some main functions)
08. Hot_Keys        : key mapping
09. Image_Editor    : editing sprites (filters, masks, etc.)
10. Documentation   : descriptions of tools from Draw, AnimK, File
11. Performance_Time: measuring the running time of different sections of code

Tools page:

- <img width="32" height="32" alt="Text" src="https://github.com/user-attachments/assets/2c5a92d6-1ea4-4274-b13d-c53768cb0da1" /> Text: drawing text (partially implemented, does not currently support multithreading);

- <img width="32" height="32" alt="Brush" src="https://github.com/user-attachments/assets/663ba7e1-190b-4e0f-81e2-c5218a124443" /> Brush: reserved for working on sprites on scene (not implemented);

- <img width="32" height="32" alt="Spline" src="https://github.com/user-attachments/assets/c91db618-9772-4316-9231-d30c747a991f" /> Spline: drawing curves/splines (it is the most optimized tool of all and has many settings for rendering, optimization, etc.);

- <img width="32" height="32" alt="Select Items" src="https://github.com/user-attachments/assets/794deb2c-8780-4386-a2a7-8a68c26ae178" /> Select Items: editing splines (uses high-performance lazy rendering algorithms and CSR-sprites capabilities);

- <img width="32" height="32" alt="Select Background Region" src="https://github.com/user-attachments/assets/d86f8891-a0da-472d-896a-44c1643da391" /> Select Background Region: reserved for working with selective edits to the scene canvas (not implemented);

- <img width="32" height="32" alt="Background" src="https://github.com/user-attachments/assets/b31c16ea-4c0d-4dec-95e6-00a9e1b04932" /> Background: background fill;

- <img width="32" height="32" alt="Post-Process" src="https://github.com/user-attachments/assets/01f43e9a-64ea-48ed-84c4-5db9dd605ae3" /> Post-Process: various layer effects like AlpahBlend, Darken, Blur, Noise, etc. (almost completely implemented only in the source code);

- <img width="32" height="32" alt="TileMap" src="https://github.com/user-attachments/assets/4c2b1140-0f6f-4298-8d0e-39ede84f25d0" /> TileMap: drawing sprites using a black-and-white mask (partially implemented, some work on the collision system);

- <img width="32" height="32" alt="Snap Grid" src="https://github.com/user-attachments/assets/c9a93d27-24b5-452b-a71b-140e1cfdb23a" /> Snap Grid: alignment of objects to a grid (only the display of the grid itself is implemented);

- <img width="32" height="32" alt="Regular Grid" src="https://github.com/user-attachments/assets/330738ad-3004-4099-a553-a7d2ea3a25af" /> Regular Grid: auxiliary grid for displaying the scale of the scene;

- <img width="32" height="32" alt="Play" src="https://github.com/user-attachments/assets/e5a1ad40-eef4-457e-b156-83647b5549f0" /> Play: starts the game loop;

- <img width="32" height="32" alt="Game Settings" src="https://github.com/user-attachments/assets/3e4c9080-b052-49ba-877a-4cafde6f069c" /> Game Settings: some basic scene settings such as canvas size, display of some objects (partially implemented);

- <img width="32" height="32" alt="Add Actor" src="https://github.com/user-attachments/assets/e58e631e-8a5a-40fe-9f50-f4dc2028f5cd" /> Add Actor: adding characters (not implemented);

- <img width="32" height="32" alt="Sound Control" src="https://github.com/user-attachments/assets/3a78cb5d-a285-4587-a26b-6f212b3b8021" /> Sound Control: some sound settings (not implemented);

All units are in active development and will be supplemented as needed.

# Additional

Executable demo(SprE_ngin_E_2_D.exe) is included, so run-n-fun.

Screenshots:
   1. Game mode: multithreading, SIMD, 100000 sprites
<img width="1562" height="897" alt="Editor_Preview1" src="https://github.com/user-attachments/assets/d4cdf93e-4d7e-4095-aa16-1e7f102ac1d9" />

   2. Editor mode: spline with 20000000 points
<img width="1562" height="897" alt="Editor_Preview2" src="https://github.com/user-attachments/assets/46b76d05-e08e-4719-84a4-a9fa3d3e67fd" />

   3. Editor mode: selected points in spline with 20000000 points
<img width="1562" height="897" alt="Editor_Preview3" src="https://github.com/user-attachments/assets/3dd94c26-e9dc-466d-a77a-78131d64a93c" />

   4. Editor mode: selected points in splines with 60000000 points
<img width="1562" height="897" alt="Editor_Preview4" src="https://github.com/user-attachments/assets/b45ded14-7d49-4cf0-bd02-c7578b519ab8" />
