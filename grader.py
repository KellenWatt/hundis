from subprocess import run, PIPE


def main():
    # TODO: Parse cli arguments
    # TODO: Logging
    # TODO: Compile code
    # TODO: Run code
    # TODO: Diff output
    # TODO: Floating-point validation
    cpp("test.txt")

    compare_output()


def cpp(input_file):
    completed_process = \
        run("g++ *.cpp -std=c++11 -o executable", stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)

    completed_process = \
        run("./executable < {} > program_output.txt".format(input_file), stdout=PIPE, stderr=PIPE, encoding="UTF-8",
            shell=True)

    if completed_process.returncode != 0:
        exit(1)


def compare_output():
    completed_process = run("diff test_output.txt program_output.txt", shell=True, stdout=PIPE, stderr=PIPE)

    if completed_process.returncode != 0:
        exit(1)

if __name__ == "__main__":
    main()
