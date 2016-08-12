pyfly2
======

Python wrapper for Point Grey Research's FlyCapture2 C API


Introduction
------------

pyfly2 slowly coming together, a lot slower than I want, but getting there.

Note: This module is for Python2 and hasn't yet been updated to work with 
Python3.


Status
------

This wrapper is currently under development.

What works:  
   - Creating flycapture2 context
   - Creating single camera object and enabling capture mode
   - Grabbing frames
   - A few simple demos:
      - Scriptable frame grab
      - "Live preview" GUI with frame grab
      
What still needs to be done:
   - Robustness (USB3 driver seems picky about shutting down the context.  This is a drag when debugging new features)
   - Illustrate using multiple cores to enhance image pipeline using ZeroMQ

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


(c) Keith Brafford, 2014

