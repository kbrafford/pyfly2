pyfly2
======

Python wrapper for Point Grey Research's FlyCapture2 C API


Introduction
------------

Hey!


Status
------

This wrapper is currently under development.

Requirements
------------

-  python
-  cython
-  Point Grey FlyCapture 2 SDK

Installation
------------

1) Install the FlyCapture2 SDK

2) Edit setup.py and point FLYCAPTURESDK to the root of the SDK

3) From the FlyCapture2 SDK tree, copy these files to the package directory:

   * FlyCapture2_Cd_v90.dll
   * FlyCapture2d_v90.dll
   * libiomp5md.dll

4) python setup.py build_ext --inplace

License:
--------

MIT


(c) Keith Brafford, 2012

