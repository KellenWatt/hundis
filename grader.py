from subprocess import run, PIPE
import re


def main():
    # TODO: Parse cli arguments
    # TODO: Logging
    # TODO: Compile code
    # TODO: Run code
    # TODO: Diff output
    # TODO: Floating-point validation
    # cpp("test.txt")

    # compare_output()
    floating_point_validation()


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
        return floating_point_validation()

    return True


def floating_point_validation(delta=.001):
    sample_output = open("test_output.txt", "r")
    program_output = open("program_output.txt", "r")

    sample_floats = [word.strip("\n") for line in sample_output for word in line.split(" ")
                     if re.match("(\+|-)?[0-9]+\.[0-9]+", word)]

    program_floats = [word.strip("\n") for line in program_output for word in line.split(" ")
                      if re.match("(\+|-)?[0-9]+\.[0-9]+", word)]

    if len(sample_floats) == 0:
        # No floats to look at
        return False
    elif len(sample_floats) != len(program_floats):
        # Output is certainly wrong, there aren't the same number of floats
        return False

    # Same number of floats
    for i in range(len(sample_floats)):
        # Grab the correct answer
        f = sample_floats[i]

        # Convert it to a float
        f = float(f)

        # Create an upper and lower bound based on delta
        window = f - delta, f + delta

        # Grab the program answer
        program_answer = program_floats[i]

        # Convert it
        program_answer = float(program_answer)

        # Check if the program output is within that window
        if not (window[0] <= program_answer <= window[1]):
            return False

    # Reached the end without returning false, return true
    return True

if __name__ == "__main__":
    main()
