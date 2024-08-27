import matplotlib.pyplot as plt
import numpy as np
import csv


def read_results(filename):
    with open(filename, "r") as f:
        xs, ys = [], []
        reader = csv.reader(f)
        next(reader)
        for pos, _, score, _ in reader:
            xs.append(int(pos)), ys.append(float(score))
        return np.array(xs), np.array(ys)


def make_graph(xs, ys, threshold):
    _, ax = plt.subplots()
    ax.plot(xs, ys, color="green")
    # Top
    ax.fill_between(xs, ys, threshold, where=ys > threshold, color="yellow")
    # Bottom
    ax.fill_between(xs, ys, threshold, where=ys < threshold, color="green")
    # Midline
    plt.axhline(threshold, color="black")
    plt.xticks(np.arange(min(xs), max(xs), 10))
    plt.yticks(np.arange(min(ys), max(ys), 0.02))
    plt.show()


def main():
    filename = "./epitope_match/EBV_ad6_IEDB.csv"
    threshold = 0.5
    xs, ys = read_results(filename)
    make_graph(xs, ys, threshold)


if __name__ == "__main__":
    main()
