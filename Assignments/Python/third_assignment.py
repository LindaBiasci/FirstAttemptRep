#Linda Biasci
"""A Python program that handles a sequence of voltage measurements at different times.
To do so, a class is implemented from scratch, using iterators and decorators."""

import numpy as np
from scipy import interpolate
from matplotlib import pyplot as plt

class VoltageData:
    """A class to deal with voltage measurement in time"""
    def __init__(self, times, voltages):
        """Constructor: expected two iterables with the same length.
        A two-dimensional array is created with times (0) and voltages (1)."""
        if len(times) != len(voltages):
            raise ValueError('Error: times and voltages must have the same length')
        t = np.array(times, dtype=np.float64)
        v = np.array(voltages, dtype=np.float64)
        self._data = np.column_stack([t, v])
        #An attribute to interpolate data (cubic spline for "regular" signals)
        self.spline = interpolate.InterpolatedUnivariateSpline(
            self.times, self.voltages, k = 3
        )

    @classmethod
    def from_file(cls, file_path):
        """Alternative constructor: the class can be initialised from a text file"""
        t, v = np.loadtxt(file_path, unpack=True)
        return cls(t, v)

    def __getitem__(self, index):
        """The class must be index-able:
        this special method is needed to have access to values with the [] syntax"""
        return self._data[index]

    @property
    def times(self):
        """Slicing syntax, [0] refers to time values"""
        return self._data[:, 0]

    @property
    def voltages(self):
        """Slicing syntax, [1] refers to voltage values"""
        return self._data[:, 1]

    def __len__(self):
        """Calling the len() function on a class instance must return the number of entries,
        i.e., the number of rows of the two-dimensional array"""
        return len(self._data[0])

    def __iter__(self):
        """The class must be iterable: at each iteration, a numpy array of two values,
        corresponding to an entry in the file must be returned"""
        return iter(self._data)

    #The print() function must work on class instances.
    #The output must show one entry, as well as the entry index, per line.
    #In order to do so, both a __repr__ method and a __str__ method are required.
    #Moreover, this is good practice for debugging

    def __repr__(self):
        """For each row, print its two values in a string.
        Join each row, i.e. each entry, line after line."""
        return '\n'.join('{} {}'.format(row[0], row[1]) for row in self)

    def __str__(self):
        """Print one entry per line in a string, but more user-friendly"""
        row_fmt = 'Row {}: {:.2f} s, {:.2f} mV'
        return '\n'.join(row_fmt.format(i, entry[0], entry[1]) for i, entry in enumerate(self))

    def __call__(self, t):
        """The class must be callable,
        returning an interpolated tension value for a given time value"""
        return self.spline(t)

    def plot(self, ax=None, **some_data):
        """Default option: a new figure is created to plot data"""
        if ax is not None:
            plt.sca(ax)
        else:
            ax = plt.figure('Voltage data')

        plt.plot(self.times, self.voltages, **some_data)
        plt.xlabel('Time (s)')
        plt.ylabel('Voltages (mV)')
        plt.grid(True)


#examples and tests
if __name__ == "__main__":
    datatest = VoltageData.from_file('sample_data_file.txt')
    print(datatest)
    T = 0.45
    example = VoltageData.__call__(datatest, T)
    print(f'For time = {T} s, voltage = {example} mV')
    assert datatest[5, 0] == 0.6
    print(repr(datatest))
    datatest.plot(marker = 'o', color = 'red')
    plt.show()
