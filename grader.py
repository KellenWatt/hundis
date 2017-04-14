from subprocess import run, PIPE
import argparse
import re

MAIN_FILE = None
PROGRAM_EXECUTABLE_NAME = None
PROGRAM_OUTPUT_FILENAME = None
SOLUTION_FILENAME = None
DIFF_COMMAND = None
JAVA_COMPILE_COMMAND = "javac *.java"
JAVA_RUN_COMMAND = "java {} < {} > {}"
CPP_COMPILE_COMMAND = "g++ *.cpp -std=c++11 -o {}".format(PROGRAM_EXECUTABLE_NAME)
CPP_RUN_COMMAND = "./{} < {} > {}"
PYTHON2_RUN_COMMAND = "python2 {} < {} > {}"
PYTHON3_RUN_COMMAND = "python3 {} < {} > {}"


def main():
    # Declare the globals
    global PROGRAM_EXECUTABLE_NAME
    global PROGRAM_OUTPUT_FILENAME
    global MAIN_FILE
    global SOLUTION_FILENAME
    global DIFF_COMMAND

    # TODO: Parse cli arguments
    parser = argparse.ArgumentParser(description="A grading script to judge programming problems")

    parser.add_argument("language", help="For a list of supported languages, see the website")
    parser.add_argument("input_file", help="The input file to be fed to the user's code")
    parser.add_argument("-o", "--output_file", help="The file to have the user's code output to. "
                                                    "Defaults to \"program_output.txt\"",
                        default="program_output.txt")
    parser.add_argument("-m", "--main_file", help="For languages that mandate a specific file to run.")
    parser.add_argument("-e", "--executable", help="For languages that compile to an executable, the name of the "
                                                   "executable. Defaults to \"user_executable\"",
                        default="user_executable")
    parser.add_argument("-d", "--diff_command", help="The command used when making calls to diff. "
                                                     "Defaults to \"diff {solution_output}{user_output}\"",
                        default="diff {} {}")
    parser.add_argument("-s", "--solution_file", help="The solution file for the user's output to be compared to. "
                                                      "Defaults to \"solution_output.txt\"",
                        default="solution_output.txt")
    parser.add_argument("--delta", help="The floating-point delta to apply when validating floating-point arithmetic."
                                        "Defaults to .001", default=.001)
    args = parser.parse_args()

    # TODO: Convert this to an enum call
    language = args.language.lower()
    input_file = args.input_file
    MAIN_FILE = args.main_file
    PROGRAM_EXECUTABLE_NAME = args.executable
    PROGRAM_OUTPUT_FILENAME = args.output_file
    SOLUTION_FILENAME = args.solution_file
    DIFF_COMMAND = args.diff_command
    delta = args.delta

    # TODO: Logging
    # TODO: Compile code
    # TODO: Run code
    # TODO: Diff output
    # TODO: Floating-point validation


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
