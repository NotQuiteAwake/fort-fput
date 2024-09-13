import subprocess as sp

import numpy as np
import numpy.typing as npt
import matplotlib.pyplot as plt

from utils import Specs

FPUT = "build/fput"

def time_sim(A:float, alpha:float, **kwargs):
    specs: Specs = Specs(
        operation="time",
        N=30,
        dx=0.1,
        rho=2,
        per_cycle=1000,
        int_order=4,
        init_mode=1,
        A=A,
        k=50,
        alpha=alpha,
        recur_thresh = 0.995,
    )

    for key, val in kwargs.items():
        setattr(specs, key, val)

    print(f"A = {A:.2f}, alpha = {alpha:.4f}")

    p = sp.run(FPUT, input=specs.export(), capture_output=True, text=True)
    time = float(p.stdout)

    print(f"{time:.4f}")
    return time

time_vec = np.vectorize(time_sim, otypes = [float])

def test_A_alpha():
    # verify that changing A and a really have the same effect up to an amplitude.
    time_sim(2, 0.1)
    time_sim(1, 0.2)

def A_alpha_heatmap(A:npt.NDArray, alpha:npt.NDArray):
    # the force depends on dydx only, it suffices to change one of A and dx
    AA, aa = np.meshgrid(A, alpha)

    t = time_vec(AA, aa) 
    # t = AA * aa * 100
    print(t)

    pc = plt.pcolormesh(AA, aa, t)
    plt.colorbar(pc)
    plt.title("Recurrence time by $A$ and $\\alpha$")
    plt.xlabel("$A$")
    plt.ylabel("$\\alpha$")
    plt.savefig('recur-heatmap.pdf')
    plt.show()

def time_alpha_plot(A:float, alpha:npt.NDArray):
    t = time_vec(A, alpha) 

    plt.plot(alpha, t)
    plt.title("Recurrence time against $\\alpha$")
    plt.xlim(min(alpha), max(alpha))
    plt.xlabel("$\\alpha$")
    plt.ylabel("Time $t/s$")
    plt.savefig('time-alpha.pdf')
    plt.show()

    # log-log plot
    log_alpha = np.log(alpha)
    log_t = np.log(t)
    plt.plot(log_alpha, log_t, label = 'measured', color = 'blue')

    a, b = np.polyfit(log_alpha, log_t, deg=1)
    log_t_linear = a * log_alpha + b
    plt.plot(log_alpha,
             log_t_linear,
             label = f'$a = {a:.3f}$, $b = {b:.3f}$',
             linestyle = 'dotted',
             color = 'green'
             )

    plt.title("log-log plot, recurrence time and $\\alpha$")
    plt.xlim(min(log_alpha), max(log_alpha))
    plt.xlabel("$\\log \\alpha$")
    plt.ylabel("Time $t/s$")
    plt.legend(loc = "upper right")
    plt.savefig("log-log.pdf")
    plt.show()

def main():
    # For a while I wasn't sure myself why one would use a main function.
    # Then suddenly it came to me that if you just have __name__ == thing, the
    # variables are not scoped.......

    # A = np.linspace(0.5, 1.5, 20)
    # alpha = np.linspace(0.1, 0.2, 20)
    # A_alpha_heatmap(A, alpha)

    time_alpha_plot(A=1, alpha=np.linspace(0.025, 0.3, 100))

if __name__ == "__main__":
    main()    

