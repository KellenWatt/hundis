from subprocess import run, PIPE
import argparse
import re
from enum import Enum, IntEnum

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


# Declare the judgement return code enum
class Judgement(IntEnum):
    ACCEPTED = 0
    COMPILE_ERROR = 1
    RUNTIME_ERROR = 2
    WRONG_ANSWER = 3


# Declare the language enum
class Language(Enum):
    C = ("gcc *.c -o {}", "./{} < {} > {}")
    CPP = ("g++ *.cpp -std=c++11 -o {}", "./{} < {} > {}")
    JAVA = ("javac *.java", "java {} < {} > {}")
    PYTHON2 = (None, "python2 {} < {} > {}")
    PYTHON3 = (None, "python3 {} < {} > {}")
    
    # TODO: @Kellen, figure out the commands. Format is (COMPILE_COMMAND, RUN_COMMAND)
    C_SHARP = (None, None)
    D = (None, None)
    GO = (None, None)
    RUBY = (None, None)
    PASCAL = (None, None)
    JAVASCRIPT = (None, None)
    SCALA = (None, None)
    PHP = (None, None)
    HASKELL = (None, None)
    LISP = (None, None)
    LUA = (None, None)

    def __init__(self, compile_command, run_command):
        self.compile_command = compile_command
        self.run_command = run_command


def main():
    # Create the language->function dictionary
    functions = {Language.C: c, Language.CPP: cpp, Language.JAVA: java, Language.PYTHON2: python2,
                 Language.PYTHON3: python3, Language.C_SHARP: c_sharp, Language.D: d, Language.GO: go,
                 Language.RUBY: ruby, Language.PASCAL: pascal, Language.JAVASCRIPT: javascript, Language.SCALA: scala,
                 Language.PHP: php, Language.HASKELL: haskell, Language.LISP: lisp, Language.LUA: lua}
    
    # Declare the globals
    global PROGRAM_EXECUTABLE_NAME
    global PROGRAM_OUTPUT_FILENAME
    global MAIN_FILE
    global SOLUTION_FILENAME
    global DIFF_COMMAND

    # TODO: Parse cli arguments
    parser = argparse.ArgumentParser(description="A grading script to judge programming problems")

    parser.add_argument("language", help="Any of these languages: {}".format(
        [name for name, value in Language.__members__.items()]))
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

    language = args.language.upper()
    input_file = args.input_file
    MAIN_FILE = args.main_file
    PROGRAM_EXECUTABLE_NAME = args.executable
    PROGRAM_OUTPUT_FILENAME = args.output_file
    SOLUTION_FILENAME = args.solution_file
    DIFF_COMMAND = args.diff_command
    delta = args.delta

    # Grab the given language from the enum
    try:
        language = Language[language]
        
        # Call the appropriate function based on language
        functions[language](input_file)
        
        # Perform output validation
        return_code = compare_output(SOLUTION_FILENAME, PROGRAM_OUTPUT_FILENAME, delta)
        
        return return_code
    except KeyError:
        print("Language \"{}\" is not supported".format(language))
        exit(1)

    # TODO: Logging


def c(input_file):
    completed_process = run(Language.C.compile_command.format(PROGRAM_EXECUTABLE_NAME),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.COMPILE_ERROR)

    completed_process = \
        run(Language.C.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, PROGRAM_OUTPUT_FILENAME),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.RUNTIME_ERROR)


def cpp(input_file):
    completed_process = \
        run(Language.CPP.compile_command.format(PROGRAM_EXECUTABLE_NAME),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.COMPILE_ERROR)

    completed_process = \
        run(Language.CPP.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, PROGRAM_OUTPUT_FILENAME),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.RUNTIME_ERROR)


def java(input_file):
    if MAIN_FILE is None:
        exit(1)

    completed_process = \
        run(Language.JAVA.compile_command, stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.COMPILE_ERROR)

    # The [:-5] slice is to remove the '.java' ending from the main file
    completed_process = \
        run(Language.JAVA.run_command.format(MAIN_FILE[:-5], input_file, PROGRAM_OUTPUT_FILENAME),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.RUNTIME_ERROR)


def python2(input_file):
    if MAIN_FILE is None:
        exit(1)

    # Python is interpreted, so no need to compile
    completed_process = run(Language.PYTHON2.run_command.format(MAIN_FILE, input_file, PROGRAM_OUTPUT_FILENAME),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.RUNTIME_ERROR)


def python3(input_file):
    if MAIN_FILE is None:
        exit(1)

    # Python is interpreted, so no need to compile
    completed_process = run(Language.PYTHON3.run_command.format(MAIN_FILE, input_file, PROGRAM_OUTPUT_FILENAME),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        exit(Judgement.RUNTIME_ERROR)


def c_sharp(input_file):
    pass


def d(input_file):
    pass


def go(input_file):
    pass


def ruby(input_file):
    pass


def pascal(input_file):
    pass


def javascript(input_file):
    pass


def scala(input_file):
    pass


def php(input_file):
    pass


def haskell(input_file):
    pass


def lisp(input_file):
    pass


def lua(input_file):
    pass


def compare_output(solution_filename, program_output_filename, delta):
    completed_process = run(DIFF_COMMAND.format(program_output_filename, solution_filename),
                            shell=True, stdout=PIPE, stderr=PIPE)

    if completed_process.returncode != 0:
        return floating_point_validation(solution_filename, program_output_filename, delta)

    return Judgement.ACCEPTED


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
        return Judgement.WRONG_ANSWER
    elif len(solution_floats) != len(program_floats):
        # Output is certainly wrong, there aren't the same number of floats
        return Judgement.WRONG_ANSWER

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
            return Judgement.WRONG_ANSWER

    # Reached the end without returning false, return true
    return Judgement.ACCEPTED


if __name__ == "__main__":
    main()
