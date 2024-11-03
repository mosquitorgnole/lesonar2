LeSonar 2
=========

We're directly selling our ultrasonic sonar development kit, and releasing it under an AGPL license so you can build projects on top of our sensor.


Links
-----
- [Main project link](mosquitorgnole.com/sonar)

Photos
------

![](mosquitorgnole.com/images/IMG_1549.jpg) ![](mosquitorgnole.com/images/IMG_1530.jpg)


Specifications
--------------

*   380x TDK Invensense T3902 PDM microphones.
*   Artix-7 A100T FPGA.
*   FT601Q parralel-to-usb bridge tested at up to 200MB/s.
*   32x 40khz Ultrasonic Piezoelectric emitters
*   2 free GPIOs

Capabilities
------------

### Active sonar

*   Optimized for 40KHz operation.
*   Up to 5°x5° beamwidth.
*   Range up to 8 meters depending on target sonar cross-section.

### Passive sonar

*   Can detect a bike air chamber leak at 3 meters.

Software
========

The sonar comes with two demoes
\- 2D Slicing camera, that shows the energyscape for a specific distance.
\- 3D Camera, that shows the reflected energy with a 3d point cloud.

Both examples are made with C99 C, using Raylib and Sokol for real-time 2D/3D visualization.


Attribution
======
The receiver hardware is based on the open-source [CP SoM One](https://github.com/controlpaths/cp_som_one)
