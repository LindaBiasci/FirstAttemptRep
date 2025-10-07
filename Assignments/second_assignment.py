#Linda Biasci
"""A Python program that creates the class Particle with appropriate metods and attributes.
Classes proton and alpha are then inherited from class Particle."""

import numpy as np

class Particle:
    """Class representing a generic particle"""

    #constructor; momentum is an optional variable
    def __init__(self, mass, charge, name, momentum=0.):
        """Mass and momentum in MeV, with c=1; charge in |e|.
        Particle's mass, charge and name shall be private"""
        self._mass = mass
        self._charge = charge
        self._name = name
        self.momentum = momentum

    #properties emulate attribute which are not properly implemented in the class -> decorators

    @property
    def mass(self):
        return self._mass
    
    @property
    def charge(self):
        return self._charge
    
    @property
    def name(self):
        return self._name
    
    @property
    def momentum(self):
        return self._momentum
    
    @momentum.setter
    def momentum(self, momentum):
        if momentum < 0:
            print("Error: momentum cannot be negative\n" \
            "Type again, momentum is now set to default value")
            self._momentum = 0.
        else:
            self._momentum = momentum
    
    @property
    def energy(self):
        return np.sqrt(self.mass**2 + self.momentum**2)
    
    #set the energy value basing on momentum; energy cannot be lower than mass!
    @energy.setter
    def energy(self, energy):
        if energy < self.mass:
            print("Error: energy cannot be set to a lower value than the mass")
        else:
            self.momentum = np.sqrt(energy**2 - self.mass**2)

    @property
    def beta(self):
        return self.momentum/self.energy

    @beta.setter
    def beta(self, beta):
        if (beta<0) or (beta>1):
            print("Error: beta cannot be negative nor major than 1")
        elif (beta>=1.) and (self.mass>0):
            print("Error: beta cannot be 1 for a massive particle")
        elif (beta>0) and (self.momentum<=0.):
            print("Error: if momentum is null beta has to be null, too")
        else:
            self.momentum = beta * self.energy

    @property
    def gamma(self):
        return 1/np.sqrt(1-self.beta**2)
    
    @gamma.setter
    def gamma(self, gamma):
        if (gamma<1):
            print("Error: gamma cannot be minor than 1")
        elif (gamma>1) and (self.beta<=0.):
            print("Error: gamma must be 1 if beta is null")

    def print_info(self):
        """Print all information about particle"""
        print(f"Particle {self.name}: mass {self.mass} MeV and charge {self.charge} |e|")
        print(f"This particle has momentum of {self.momentum:.2f} MeV")

#inheritance: classes proton and alpha derived from class Particle

class proton(Particle):
    MASS = 938.
    CHARGE = +1.
    NAME = "Proton"
    def __init__(self, momentum=0.):
        Particle.__init__(self, mass=self.MASS, charge=self.CHARGE, name=self.NAME, momentum=momentum)

class alpha(Particle):
    MASS = 3727.
    CHARGE = +4.
    NAME = "Alpha"
    def __init__(self, momentum=0.):
        Particle.__init__(self, mass=self.MASS, charge=self.CHARGE, name=self.NAME, momentum=momentum)

#examples and tests
if __name__ == "__main__":
    muon=Particle(mass=105.6, charge=-1, name="Muon")
    muon.print_info()
    muon.energy = 200
    print(f"This particle has energy of {muon.energy:.2f} MeV")
    print(f"Hence, it has now momentum of {muon.momentum:.2f} MeV, and beta is {muon.beta:.2f}")
    muon.momentum = 40
    print(f"This particle has momentum of {muon.momentum:.2f} MeV")
    print(f"Hence, it has now energy of {muon.energy:.2f} MeV, and beta is {muon.beta:.2f}")
    muon.beta = -2
    print(f"Beta has been set to {muon.beta:.2f}")
    muon.gamma = 0
    print(f"Gamma has been set to {muon.gamma:.2f}")
    measured_proton = proton(150.)
    measured_proton.print_info()
    print(f"Hence, this particle has beta={measured_proton.beta:.2f}")
    measured_alpha = alpha()
    measured_alpha.energy = 4000.
    measured_alpha.print_info()
