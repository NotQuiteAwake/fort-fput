import matplotlib.pyplot as plt
from dataclasses import dataclass, field

@dataclass
class Specs:
    N:int = field(default_factory=int)
    dx:float = field(default_factory=float)
    rho:float = field(default_factory=float)

    dt:float = field(default_factory=float)

    x:list[float] = field(default_factory=list)
    A: float = field(default_factory=float)

    def parse(self, conf_line:str):
        assert(conf_line)

        conf = conf_line.strip().split()
        assert(conf[0] == '%')  # config marker
        name = conf[1]
        val = conf[2]
        
        # even when conceivable python magic still amazes me
        if hasattr(self, name):
            attr_type = type(getattr(self, name))
            val = attr_type(val)
            setattr(self, name, val)
        # otherwise silently ignore attribute.

    def get_x(self)->list[float]:
        if self.x:
            return self.x
        
        self.x = [i * self.dx for i in range(self.N)]
        return self.x

    def get_l(self)->float:
        return (self.N - 1) * self.dx

@dataclass
class Datapoint:
    time:float = field(default_factory=float)
    string:list[float] = field(default_factory=list)
    modes: list[float] = field(default_factory=list)

    def get_num_modes(self)->int:
        return len(self.modes)

class Axes:
    def __init__(self):
        self.grid_shape = (2, 2)

        self.string_ax = plt.subplot2grid(self.grid_shape, (0, 0))  
        self.modes_ax = plt.subplot2grid(self.grid_shape, (0, 1))
        self.modes_time_ax = plt.subplot2grid(self.grid_shape, (1, 0), colspan = 2)

        plt.tight_layout() 
        plt.subplots_adjust(top=0.95)

    def plot_string(self, dp: Datapoint, specs:Specs):
        x = specs.get_x()

        self.string_ax.clear()
        self.string_ax.set_title('Displacements')
        self.string_ax.set_xlim(x[0], x[-1])
        self.string_ax.set_ylim(-1.1 * specs.A, 1.1 * specs.A)
        self.string_ax.plot(x, dp.string)

    def plot_modes(self, dp: Datapoint):
        num_modes = dp.get_num_modes()

        self.modes_ax.clear() 
        self.modes_ax.set_title('Modes')
        self.modes_ax.grid(True)
        self.modes_ax.set_xlim(0, num_modes + 1)
        self.modes_ax.set_ylim(-1.1, 1.1)

        for i in range(num_modes):
            mode = dp.modes[i]
            self.modes_ax.plot([i + 1, i + 1], [0, mode],
                               linestyle = '-',
                               marker = 'o',
                               color='blue',
                               markevery = [-1]
                               ) 

    def plot_mode_time(self, data:list[Datapoint]):
        max_length = 400
        num_modes = data[-1].get_num_modes()

        self.modes_time_ax.clear()
        self.modes_time_ax.set_title('Mode amplitudes over time')
        self.modes_time_ax.set_ylim(0, 1)

        times = [d.time for d in data[-max_length:]]
        self.modes_time_ax.set_xlim(times[0], times[-1])

        # more modes will just be confusing
        for i in range(min(num_modes, 5)):
            # longer times will just be a mess
            comps = [abs(d.modes[i]) for d in data[-max_length:]]
            self.modes_time_ax.plot(times, comps, label=i)

        self.modes_time_ax.legend(loc = 'upper left')

    def plot(self, data:list[Datapoint], specs:Specs):
        self.plot_string(data[-1], specs)
        self.plot_modes(data[-1])
        self.plot_mode_time(data)

