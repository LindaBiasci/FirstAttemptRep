#Linda Biasci
"""A Python program that implements a ProbabilityDensityFunction class,
capable of throwing preudo-random number with an arbitrary distribution.
"""

import numpy as np
from scipy.interpolate import InterpolatedUnivariateSpline
from matplotlib import pyplot as plt
from scipy.stats import norm

class ProbabilityDensityFunction(InterpolatedUnivariateSpline):
    """ProbabilityDensityFunction class is inherited from InterpolatedUnivariateSpline"""

    def __init__(self, x, y, k=1):
        self._x = x
        self._y = y
        # This would use composition, but __call__ and integral would be overloaded
        #self._spline = InterpolatedUnivariateSpline(x, y, k=k)
        # By doing this, inheritance on spline is being used,
        # so there's no need for _spline, __call__, and integral anymore
        super().__init__(x, y, k=k)
        # _y is the cumulative sum of the variable y (from pdf):
        # By definition, it's positive and always increasing
        _y = self._y.cumsum()
        # Normalise the cumulative sum
        _y /= _y[-1]
        self.cdf = InterpolatedUnivariateSpline(x, _y)
        self.ppf = InterpolatedUnivariateSpline(_y, x, k=1)

    #def __call__(self, x):
    #    """Make the class callable: better than an evaluate(self, x) method"""
    #    return self._spline(x)

    def probability(self, a, b):
        """Calculate probability in a generic interval, using default integral function"""
        return super().integral(a, b)

    def rvs(self, size=100):
        """Random values generated from the Probability Point Function,
        i.e., the inverse of the Cumulative Distribution Function"""
        return self.ppf(np.random.uniform(size=size))

    def plot(self):
        """Plot the spline according to pdf"""
        x = np.linspace(self._x.min(), self._x.max(), 200)
        plt.plot(x, self(x))

# Start with a triangular distribution
X_t = np.linspace(0., 1., 30)
Y_t = 2. * X_t
pdf_t = ProbabilityDensityFunction(X_t, Y_t, k=1)

# Try with a Gaussian
X_g = np.linspace(0., 10., 300)
Y_g = norm.pdf(X_g, loc=5., scale=1.)
pdf_g = ProbabilityDensityFunction(X_g, Y_g, k=1)

plt.figure()
pdf_t.plot()
plt.grid(True)
plt.plot(X_t, pdf_t.cdf(X_t))

plt.figure()
plt.hist(pdf_t.rvs(size=100000), bins=100)

plt.figure()
pdf_g.plot()
plt.grid(True)
plt.plot(X_g, pdf_g.cdf(X_g))

plt.figure()
plt.hist(pdf_g.rvs(size=100000), bins=100)
plt.show()

#examples and tests
if __name__=="__main__":
    assert np.allclose(pdf_t(0.5), 1.)
    print(pdf_t(0.75))
    assert np.allclose(pdf_t.integral(0., 1.,), 1.)
    print(pdf_t.integral(0., 0.5))
