from subprocess import run, PIPE
import re

PROGRAM_EXECUTABLE_NAME = "user_executable"
JAVA_COMPILE_COMMAND = "javac *.java"
JAVA_RUN_COMMAND = "java {} < {} > {}"
CPP_COMPILE_COMMAND = "g++ *.cpp -std=c++11 -o {}".format(PROGRAM_EXECUTABLE_NAME)
CPP_RUN_COMMAND = "./{} < {} > {}"
PYTHON2_RUN_COMMAND = "python2 {} < {} > {}"
PYTHON3_RUN_COMMAND = "python3 {} < {} > {}"
INPUT_FILENAME = "input.txt"
PROGRAM_OUTPUT_FILENAME = "program_output.txt"
SOLUTION_OUTPUT_FILENAME = "solution_output.txt"
DIFF_COMMAND = "diff {} {}"


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


def java(main_file, input_file, output_file_name):
    completed_process = \
        run(JAVA_COMPILE_COMMAND,
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)

    # The [:-5] slice is to remove the '.java' ending from the main file
    completed_process = \
        run(JAVA_RUN_COMMAND.format(main_file[:-5], input_file, output_file_name),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)


def python2(script_file, input_file, output_file_name):
    # Python is interpreted, so no need to compile

    completed_process = run(PYTHON2_RUN_COMMAND.format(script_file, input_file, output_file_name),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)


def python3(script_file, input_file, output_file_name):
    # Python is interpreted, so no need to compile

    completed_process = run(PYTHON3_RUN_COMMAND.format(script_file, input_file, output_file_name),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)


def cpp(executable_name, input_file, output_file_name):
    completed_process = \
        run(CPP_COMPILE_COMMAND.format(executable_name),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)

    completed_process = \
        run(CPP_RUN_COMMAND.format(executable_name,input_file, output_file_name),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(1)


def compare_output(solution_filename, program_output_filename):
    completed_process = run(DIFF_COMMAND.format(program_output_filename, solution_filename),
                            shell=True, stdout=PIPE, stderr=PIPE)

    if completed_process.returncode != 0:
        return floating_point_validation(solution_filename, program_output_filename)

    return True


def floating_point_validation(solution_filename, program_output_filename, delta=.001):
    solution_output = open(solution_filename, "r")
    program_output = open(program_output_filename, "r")

    # Find all floating point numbers and throw them into a list
    solution_floats = [word.strip("\n") for line in solution_output for word in line.split(" ")
                       if re.match("(\+|-)?[0-9]+\.[0-9]+", word)]

    program_floats = [word.strip("\n") for line in program_output for word in line.split(" ")
                      if re.match("(\+|-)?[0-9]+\.[0-9]+", word)]

    if len(solution_floats) == 0:
        # No floats to look at
        return False
    elif len(solution_floats) != len(program_floats):
        # Output is certainly wrong, there aren't the same number of floats
        return False

    # Same number of floats
    for i in range(len(solution_floats)):
        # Grab the correct answer
        f = solution_floats[i]

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
