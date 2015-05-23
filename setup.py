#!/usr/bin/env python

# Build the pyd with python setup.py build_ext --inplace
desc = """This is Keith Brafford's first attempt at
a wrapper for the FlyCapture2 C API.
"""

from setuptools import setup, Extension
from Cython.Distutils import build_ext

if os.path.exists('C:/Program Files (x86)/Point Grey Research/FlyCapture2'):
    fc2_sdk = 'C:/Program Files (x86)/Point Grey Research/FlyCapture2'
else:
1    fc2_sdk = 'C:/Program Files/Point Grey Research/FlyCapture2'

if os.path.exists(os.path.join(fc2_sdk, '/lib/C')):
    fc2_lib = '/lib/C'
elif os.path.exists(os.path.join(fc2_sdk, '/lib64/C')):
    fc2_lib = '/lib64/C'

fc2_inc = os.path.join(fc2_sdk, 'include')

setup(name = 'pyfly2',
      version = '0.2',
      author = 'Keith Braddord',
      license = 'BSD',
      description = desc,
      cmdclass = {'build_ext': build_ext},

      ext_modules = [Extension('pyfly2',
                               sources = ['pyfly2.pyx'],
                               include_dirs = ['.', fc2_inc],
                               extra_compile_args = [],
                               extra_link_args = [],
                               libraries = ['FlyCapture2_Cd_v90'],
                               library_dirs = [f2c_lib])],

      data_files = ['FlyCapture2_Cd_v90.dll', 'FlyCapture2d_v90.dll',
                    'libiomp5md.dll'],
      )
