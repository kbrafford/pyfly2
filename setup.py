#!/usr/bin/env python

# Build the pyd with 
#   python setup.py build_ext --inplace
# 

# from setuptools import setup, Extension
from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext
import os.path

desc = """This is Keith Brafford's first attempt at
a wrapper for the FlyCapture2 C API.
"""

if os.name=='posix':
    fc2_inc='/usr/include/flycapture'
    fc2_shared='flycapture-c'
    fc2_lib='/usr/lib'
    data_files=[]
else:
    # Windows
    if os.path.exists('C:/Program Files (x86)/Point Grey Research/FlyCapture2'):
        fc2_sdk = 'C:/Program Files (x86)/Point Grey Research/FlyCapture2'
    else:
        fc2_sdk = 'C:/Program Files/Point Grey Research/FlyCapture2'

    if os.path.exists(os.path.join(fc2_sdk, 'lib/C')):
        fc2_lib = os.path.join(fc2_sdk, 'lib/C')
    elif os.path.exists(os.path.join(fc2_sdk, 'lib64/C')):
        fc2_lib = os.path.join(fc2_sdk, 'lib64/C')
    fc2_shared='FlyCapture2_Cd_v90'
    data_files=['FlyCapture2_Cd_v90.dll', 'FlyCapture2d_v90.dll', 'libiomp5md.dll']
    fc2_inc = os.path.join(fc2_sdk, 'include')

setup(name = 'pyfly2',
      version = '0.2',
      author = 'Keith Braddord',
      license = 'BSD',
      description = desc,
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension('pyfly2', ['pyfly2.pyx'],
                               include_dirs = ['.', fc2_inc],
                               extra_compile_args = [],
                               extra_link_args = [],
                               libraries = [fc2_shared],
                               library_dirs = [fc2_lib])],
                               data_files = data_files,
      )
