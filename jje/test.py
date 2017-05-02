import math


def main():
    n = int(input())

    for i in range(n):
        radius = float(input())
        print(3.14 * pow(radius, 2))


if __name__ == '__main__':
    main()