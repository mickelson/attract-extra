attract-extra
=============

Attract-Mode Extras

Where possible, shaders have been built to be universal between Mame and AttractMode.
Mame is unable to use variables of 'uniform' type, which are required if you want to assign variables to the shader from .nut scripts.
In most cases, the MAME specific shader will be packaged on it's own, and this can also be used in AttractMode, but you will be unable to assign new values to the variables from within .nut scripts.
