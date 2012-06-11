import os.path, platform
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
#bits,foo = platform.architecture()

#
# Build the pyd with python setup.py build_ext --inplace
#
desc = """This is Keith Brafford's first attempt at 
a wrapper for the FlyCapture2 C API.
"""

FLYCAPTURESDK = r'C:\Program Files (x86)\Point Grey Research\FlyCapture2'
FLYCAPTURE2LIBDIR = os.path.join(FLYCAPTURESDK, 'lib')

setup(
    name = 'pyflyc2',
    version = '0.1',
    description = desc,
    cmdclass = {'build_ext': build_ext},
    data_files = ["FlyCapture2_Cd_v90.dll",
                  "FlyCapture2d_v90.dll", 
                  "libiomp5md.dll",
                  ],
                  
    #packages = [''],
    ext_modules = [Extension("pyfly2",
                             ["pyfly2.pyx"],
                             include_dirs = [".",
                                             os.path.join(FLYCAPTURESDK,'include'),
                                             ],
                             extra_compile_args = [],
                             extra_link_args = [],
                             libraries = ['FlyCapture2_Cd_v90'],
                             library_dirs = [os.path.join(FLYCAPTURE2LIBDIR, 'C')]
                             )
                   ],
    )


