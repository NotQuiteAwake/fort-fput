import matplotlib.pyplot as plt
from sys import stdin
import os
from utils import Specs, Datapoint, Axes
import subprocess

FPS_TARGET:float = 60.0
FIG_DIR:str = 'figs/'
CMD:str = ('ffmpeg -y -framerate {fps:.5f} -start_number 0'
           ' -i ./{fig_dir}/%d.svg -vf scale=1280:720 -vcodec libx264 output.mp4')

def read_float_line(line:str):
    return [float(num) for num in line.split()]

if __name__ == '__main__':
    os.makedirs(FIG_DIR, exist_ok = True)

    axes:Axes = Axes() 
    specs:Specs = Specs()
    data:list[Datapoint] = []
    count:int = 0
    string_read:bool = False

    # read in configs
    for line in stdin:
        line = line.strip()
         
        # a "metadata" line
        if line and line[0] == '%':
            specs.parse(line)
        # first visual separator, end of config section
        elif line == '-' * 5:
            break
        else:
            raise IOError("Invalid output file format.")

    sampling_steps:int = int((1.0 / FPS_TARGET) / specs.dt)
    if sampling_steps == 0:
        # dt larger than that maximum for required FPS_TARGET
        sampling_steps = 1

    dt_frames:float = specs.dt * sampling_steps
    fps:float = 1.0 / dt_frames

    for line in stdin:
        line = line.strip()

        # visual seperator, step-on to next timestep
        if line == '-' * 5:
            count += 1
        # implements a subsampling of results
        elif count % sampling_steps == 0:
            if not string_read:
                point = Datapoint()
                point.time = count * specs.dt
                point.string = read_float_line(line)
                data.append(point)

                string_read = True
            else:
                data[-1].modes = read_float_line(line)
                string_read = False

                axes.plot(data, specs)

                sample_count = count // sampling_steps
                plt.savefig(os.path.join(FIG_DIR, str(sample_count) + '.svg'))

                print(f"{point.time:.2f}", end = " ", flush = True)
                if (sample_count + 1) % 10 == 0:
                    print()

#                 if sample_count > 100:
#                     break

    cmd = CMD.format(fps = fps, fig_dir = FIG_DIR)
    print(cmd)

    subprocess.run(cmd.split()) 
