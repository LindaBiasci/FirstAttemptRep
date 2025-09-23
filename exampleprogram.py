#Linda Biasci
#Example program: converting an acoustic intensity to its equivalent sound level in dB

import numpy as np 

I0 = 10e-12
"""reference sound intensity in [Watt/m^2]"""

def conversion(x):
    L = 10 * np.log10(x)
    return L
"""x needs to be in [Watt/m^2] so that L is a sound level in dB"""
