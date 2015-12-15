from distutils.core import setup
from Cython.Build import cythonize


setup(
    name='cython-sparsehash',
    version='0.1',
    url='https://github.com/Pastafarianist/cython-sparsehash',
    description="Cython declarations and bindings for the Google's Sparsehash library.",
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Environment :: Console',
        'Operating System :: OS Independent',
        'Intended Audience :: Science/Research',
        'License :: Freely Distributable',
        'Programming Language :: Python',
        'Topic :: Scientific/Engineering'
    ],
    ext_modules = cythonize(
        'sparsehash.pyx',
        language='c++'
    ),
)
