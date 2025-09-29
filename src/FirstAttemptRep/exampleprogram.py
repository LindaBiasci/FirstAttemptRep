#Linda Biasci
"""Converting an acoustic intensity to its equivalent sound level in dB"""

import numpy as np
#reference sound intensity in [Watt/m^2]
I0=10e-12

def conversion(x):
    """x needs to be in [Watt/m^2] so that its correspondent sound level, in dB, is returned.
    x can be int, float, numpy array >>> returns int, float, numpy array respectively.
    
    For instance:
    >>> conversion(10e-10)
    20.0

    >>> conversion(2.3*10e-8)
    43.61727836017593

    >>> conversion(np.array([10e-10, 10e-9, 100000.0]))
    array([ 20.,  30., 160.])
    """
    return 10*np.log10(x/I0)
