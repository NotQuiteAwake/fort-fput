import matplotlib.pyplot as plt
from sys import stdin
from data import Specs, Datapoint, Axes

def read_float_line(line:str):
    return [float(num) for num in line.split()]

if __name__ == '__main__':
    axes:Axes = Axes() 
    specs:Specs = Specs()
    data:list[Datapoint] = []
    count:int = 0
    string_read:bool = False

    for line in stdin:
        line = line.strip()

        # a "metadata" line
        # extract only what is useful
        if line and line[0] == '%':
            if 'lattice param' in line:
                specs.lat_param = float(line.split()[-1])
            elif 'step size' in line:
                specs.step_size = float(line.split()[-1])
            elif 'size' in line:
                specs.size = int(line.split()[-1])
            elif 'amplitude' in line:
                specs.amp = float(line.split()[-1]) 

        # a visual separator, ignore
        elif ('-' * 5) in line:
            count += 1

        # TODO: 200 is a sampling parameter. Get that into specs
        elif count % 50 == 1:
            if not string_read:
                data.append(Datapoint())
                data[-1].time = count * specs.step_size
                data[-1].string = read_float_line(line)
                string_read = True
            else:
                data[-1].modes = read_float_line(line)
                string_read = False

                axes.plot(data, specs)
                print(count // 50)
                plt.savefig('tests/' + str(count // 50) + '.svg')

