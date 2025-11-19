
# It is a lightweight 2D game engine(written on Object Pascal and compilled in Lazarus). 
Of the features, I can note the super high performance of splines and sprites(work is still being done on it). 
Killer features: 
- thanks to the use of special structures like CSR (Compressed Sparse Row), editing even in software mode becomes incredibly fast (the complexity of the calculation depends only on the number of selected points and is almost independent of the number of all existing points on the scene);
- thanks to the "dirty rectangles" technology, scrolling of background objects occurs almost very quickly, which allows for the rendering of very large sprites (more than 30kx30k pixels) as background objects;
- using multi-threaded processing in conjunction with SIMD optimizations, it is possible to achieve quite decent speed even in software rendering mode.

In the future, a powerful editor for sprites, splines and other game objects will be available.
Executable demo(SprE_ngin_E_2_D.exe) is included, so run-n-fun 😉. 

Brief description of main modules:
1. Fast_AnimK       : animation(particles,physics,hair,fluid effects etc.)
2. Fast_GL          : initializing GLSL shaders
3. Fast_Graphics    : rendering of primitives(like a line, rectangle,circle), filters, blitters, CSR-sprites processing etc.
4. Fast_UI          : working with UI/UX elements
5. Fast_Scene_Tree  : scene object manager
6. Fast_SIMD        : some SIMD powered routines
7. Fast_Threads     : working with threads(in particular, implementations of multi-threaded variants of some functions from other modules)
8. Hot_Keys         : key mapping
9. Image_Editor     : editing sprites(filters, masks, etc.)
10. Documentation   : descriptions of tools from Draw, AnimK, File
11. Performance_Time: measuring the running time of different sections of code

All units are in active development and will be supplemented as needed.

Screenshots:
   1. Game mode: multithreading, SIMD, 100000 sprites
<img width="1562" height="897" alt="Editor_Preview1" src="https://github.com/user-attachments/assets/d4cdf93e-4d7e-4095-aa16-1e7f102ac1d9" />

   2. Editor mode: spline with 20000000 points
<img width="1562" height="897" alt="Editor_Preview2" src="https://github.com/user-attachments/assets/46b76d05-e08e-4719-84a4-a9fa3d3e67fd" />

   3. Editor mode: selected points in spline with 20000000 points
<img width="1562" height="897" alt="Editor_Preview3" src="https://github.com/user-attachments/assets/3dd94c26-e9dc-466d-a77a-78131d64a93c" />

   4. Editor mode: selected points in splines with 60000000 points
<img width="1562" height="897" alt="Editor_Preview4" src="https://github.com/user-attachments/assets/b45ded14-7d49-4cf0-bd02-c7578b519ab8" />
