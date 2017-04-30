from subprocess import run, PIPE
import argparse
import re
from enum import Enum, IntEnum
import logging
from os import listdir, makedirs
from os.path import exists

MAIN_FILE = None
PROGRAM_EXECUTABLE_NAME = None
PROGRAM_OUTPUT_FILENAME = None
SOLUTION_FILENAME = None
DIFF_COMMAND = None


# Declare the judgement return code enum
class Judgement(IntEnum):
    ACCEPTED = 0
    COMPILE_ERROR = 1
    RUNTIME_ERROR = 2
    WRONG_ANSWER = 3
    GRADER_ERROR = 4


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
    logging.basicConfig(level=logging.DEBUG)
    logging.info("Grader started")

    # Create the language->function dictionary
    compile_functions = {Language.C: compile_c, Language.CPP: compile_cpp, Language.JAVA: compile_java,
                         Language.PYTHON2: None, Language.PYTHON3: None, Language.C_SHARP: compile_c_sharp,
                         Language.D: compile_d, Language.GO: compile_go, Language.RUBY: compile_ruby,
                         Language.PASCAL: compile_pascal, Language.JAVASCRIPT: None, Language.SCALA: compile_scala,
                         Language.PHP: None, Language.HASKELL: None, Language.LISP: None, Language.LUA: None}

    run_functions = {Language.C: run_c, Language.CPP: run_cpp, Language.JAVA: run_java, Language.PYTHON2: run_python2,
                     Language.PYTHON3: run_python3, Language.C_SHARP: run_c_sharp, Language.D: run_d,
                     Language.GO: run_go, Language.RUBY: run_ruby, Language.PASCAL: run_pascal,
                     Language.JAVASCRIPT: run_javascript, Language.SCALA: run_scala, Language.PHP: run_php,
                     Language.HASKELL: run_haskell, Language.LISP: run_lisp, Language.LUA: run_lua}

    # Declare the globals
    global PROGRAM_EXECUTABLE_NAME
    global PROGRAM_OUTPUT_FILENAME
    global MAIN_FILE
    global SOLUTION_FILENAME
    global DIFF_COMMAND

    # Parse cli arguments
    parser = argparse.ArgumentParser(description="A grading script to judge programming problems")

    parser.add_argument("language", help="Any of these languages: {}".format(
        [name for name, value in Language.__members__.items()]))
    parser.add_argument("-o", "--output_file", help="The file to have the user's code output to. "
                                                    "Defaults to \"output/<input_filename>.out\"",
                        default="output/{}.out")
    parser.add_argument("-m", "--main_file", help="For languages that mandate a specific file to run.")
    parser.add_argument("-e", "--executable", help="For languages that compile to an executable, the name of the "
                                                   "executable. Defaults to \"user_executable\"",
                        default="user_executable")
    parser.add_argument("-d", "--diff_command", help="The command used when making calls to diff. "
                                                     "Defaults to \"diff {solution_output}{user_output}\"",
                        default="diff {} {}")
    parser.add_argument("-s", "--solution_file", help="The solution file for the user's output to be compared to. "
                                                      "Defaults to \"output/<input_filename>.sol\"",
                        default="output/{}.sol")
    parser.add_argument("--delta", help="The floating-point delta to apply when validating floating-point arithmetic."
                                        "Defaults to .001", default=.001)
    parser.add_argument("--diff_files", help="Skip running code and compare output directly", action="store_true")
    parser.add_argument("--debug", help="Turns on debug output", action="store_true")
    args = parser.parse_args()

    # Grab values out of the arg parser
    language = args.language.upper()
    MAIN_FILE = args.main_file
    PROGRAM_EXECUTABLE_NAME = args.executable
    PROGRAM_OUTPUT_FILENAME = args.output_file
    SOLUTION_FILENAME = args.solution_file
    DIFF_COMMAND = args.diff_command
    delta = args.delta
    diff_files = args.diff_files

    # They want to run code and then diff
    if not diff_files:
        logging.info("--diff_files was not passed. Determining language")
        # Grab the given language from the enum
        try:
            language = Language[language]

            logging.info("Using {} as a language".format(language.name))

            # Call the appropriate compile function based on language, don't if its lookup is None
            func = compile_functions[language]

            if func is not None:
                return_code = func()
            else:
                return_code = None

            if return_code is not None:
                logging.info("{} compilation: return code {}".format(language.name, return_code))
                exit(return_code)

            # Make an output directory if it doesn't exist
            if not exists("output"):
                makedirs("output")

            # Loop over input files and run code
            for file in listdir("input/"):
                file_name = file[:file.find(".")]
                run_functions[language]("input/" + file, PROGRAM_OUTPUT_FILENAME.format(file_name))

                # Perform output validation
                logging.info("Running output validation")
                return_code = compare_output(SOLUTION_FILENAME.format(file_name),
                                             PROGRAM_OUTPUT_FILENAME.format(file_name), delta)

                # If we get a non-accept return code
                if return_code != Judgement.ACCEPTED:
                    logging.info("One of the test cases could not be validated. Exiting early")
                    return return_code.value

            logging.info("All test cases passed")
            return return_code.value
        except KeyError:
            logging.critical("Language \"{}\" is not supported".format(language))
            exit(1)
    else:
        # Just diff the files
        logging.info("--diff_files passed. Running only output validation")

        # Make an output directory if it doesn't exist
        if not exists("output"):
            makedirs("output")

        return_code = Judgement.GRADER_ERROR

        # Loop over input files and run code
        for file in listdir("input/"):
            file_name = file[:file.find(".")]
            run_functions[language]("input/" + file, PROGRAM_OUTPUT_FILENAME.format(file_name))

            # Perform output validation
            logging.info("Running output validation")
            return_code = compare_output(SOLUTION_FILENAME.format(file_name),
                                         PROGRAM_OUTPUT_FILENAME.format(file_name), delta)

            # If we get a non-accept return code
            if return_code != Judgement.ACCEPTED:
                logging.info("One of the test cases could not be validated. Exiting early")
                return return_code.value

        logging.info("All test cases passed")
        return return_code.value


def compile_c():
    logging.debug("Running command: \"{}\"".
                  format(Language.C.compile_command.format(PROGRAM_EXECUTABLE_NAME)))
    completed_process = run(Language.C.compile_command.format(PROGRAM_EXECUTABLE_NAME),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical("Compile Error! gcc returned code {}".format(completed_process.returncode))
        exit(Judgement.COMPILE_ERROR)


def run_c(input_file, output_file):
    logging.debug("Running command: \"{}\"".
                  format(Language.C.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, output_file)))
    completed_process = \
        run(Language.C.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, output_file),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical(
            "Runtime error! User code returned non-zero exit code {}!".format(completed_process.returncode))
        exit(Judgement.RUNTIME_ERROR)


def compile_cpp():
    logging.debug("Running command: \"{}\"".
                  format(Language.CPP.compile_command.format(PROGRAM_EXECUTABLE_NAME)))
    completed_process = \
        run(Language.CPP.compile_command.format(PROGRAM_EXECUTABLE_NAME),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical("Compile Error! g++ returned code {}".format(completed_process.returncode))
        exit(Judgement.COMPILE_ERROR)


def run_cpp(input_file, output_file):
    logging.debug("Running command: \"{}\"".
                  format(Language.CPP.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, output_file)))
    completed_process = \
        run(Language.CPP.run_command.format(PROGRAM_EXECUTABLE_NAME, input_file, output_file),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical(
            "Runtime error! User code returned non-zero exit code {}!".format(completed_process.returncode))
        exit(Judgement.RUNTIME_ERROR)


def compile_java():
    logging.debug("Running command: \"{}\"".
                  format(Language.JAVA.compile_command))
    completed_process = \
        run(Language.JAVA.compile_command, stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical("Compile Error! javac returned code {}".format(completed_process.returncode))
        exit(Judgement.COMPILE_ERROR)


def run_java(input_file, output_file):
    if MAIN_FILE is None:
        logging.critical("Error! No main file defined while using java!")
        exit(1)

    # The [:-5] slice is to remove the '.java' ending from the main file
    logging.debug("Running command: \"{}\"".
                  format(Language.JAVA.run_command.format(MAIN_FILE[:-5], input_file, output_file)))

    completed_process = \
        run(Language.JAVA.run_command.format(MAIN_FILE[:-5], input_file, output_file),
            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical(
            "Runtime error! User code returned non-zero exit code {}!".format(completed_process.returncode))
        exit(Judgement.RUNTIME_ERROR)


def run_python2(input_file, output_file):
    if MAIN_FILE is None:
        logging.critical("Error! No main file defined while using python2!")
        exit(1)

    # Python is interpreted, so no need to compile
    logging.debug("Running command: \"{}\"".
                  format(Language.PYTHON2.run_command.format(MAIN_FILE, input_file, output_file)))
    completed_process = run(Language.PYTHON2.run_command.format(MAIN_FILE, input_file, output_file),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.critical(
            "Runtime error! User code returned non-zero exit code {}!".format(completed_process.returncode))
        exit(Judgement.RUNTIME_ERROR)


def run_python3(input_file, output_file):
    if MAIN_FILE is None:
        logging.critical("Error! No main file defined while using python3!")
        exit(1)

    # Python is interpreted, so no need to compile
    logging.debug("Running command: \"{}\"".
                  format(Language.PYTHON3.run_command.format(MAIN_FILE, input_file, output_file)))
    completed_process = run(Language.PYTHON3.run_command.format(MAIN_FILE, input_file, output_file),
                            stdout=PIPE, stderr=PIPE, encoding="UTF-8", shell=True)

    if completed_process.returncode != 0:
        logging.info("Non-zero exit code! User's code returned {}".format(completed_process.returncode))
        exit(Judgement.RUNTIME_ERROR)


def compile_c_sharp():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_c_sharp(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compile_d():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_d(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compile_go():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_go(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compile_ruby():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_ruby(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compile_pascal():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_pascal(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_javascript(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compile_scala():
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_scala(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_php(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_haskell(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_lisp(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def run_lua(input_file, output_file):
    logging.info("Not yet implemented")
    raise NotImplementedError()


def compare_output(solution_filename, program_output_filename, delta):
    logging.debug("Running diff command \"{}\"".format(DIFF_COMMAND.format(program_output_filename, solution_filename)))
    completed_process = run(DIFF_COMMAND.format(program_output_filename, solution_filename),
                            shell=True, stdout=PIPE, stderr=PIPE)

    if completed_process.returncode != 0:
        logging.info("Non-zero exit code on diff. Starting manual validation")
        return floating_point_validation(solution_filename, program_output_filename, delta)

    logging.info("Regular diff accepted. Output validated")
    return Judgement.ACCEPTED


def floating_point_validation(solution_filename, program_output_filename, delta):
    solution_output = None
    program_output = None
    try:
        solution_output = open(solution_filename, "r")
    except FileNotFoundError:
        logging.critical("Error: No solution file \"{}\" found!".format(solution_filename))
        exit(-1)

    try:
        program_output = open(program_output_filename, "r")
    except FileNotFoundError:
        logging.critical("Error: No program output file \"{}\" found!".format(program_output_filename))
        exit(-1)

    solution_line = solution_output.readline()
    while solution_line != "":
        output_line = program_output.readline()

        if output_line == "":
            # Program output hit EOF and the solution has not
            logging.info("User output file too short! Manual validation failed")
            return Judgement.WRONG_ANSWER

        solution_words = solution_line.split(" ")
        output_words = output_line.split(" ")

        for i in range(len(solution_words)):
            # Grab each word
            solution_word = solution_words[i].strip("\n")
            output_word = output_words[i].strip("\n")

            logging.debug("Comparing {} and {}".format(solution_word, output_word))

            # Is this word in the solution a float?
            if re.match("(\+|-)?[0-9]+\.[0-9]+", solution_word):
                logging.debug("{} is a float".format(solution_word))
                # Check the other one too
                if re.match("(\+|-)?[0-9]+\.[0-9]+", output_word):
                    logging.debug("{} is also a float".format(output_word))
                    # They're both floats. Check the window

                    # Convert them
                    solution_float = float(solution_word)
                    output_float = float(output_word)

                    # Create an upper and lower bound based on delta
                    window = solution_float - delta, solution_float + delta
                    logging.debug("Float window with delta={}: [{}, {}]".format(delta, window[0], window[1]))

                    # Check if the program output is within that window
                    if not (window[0] <= output_float <= window[1]):
                        logging.critical("Error! {} is not in [{}, {}]".format(output_float, window[0], window[1]))
                        return Judgement.WRONG_ANSWER
                else:
                    # Other word isn't even a float...
                    logging.debug("{} is NOT a float. Wrong answer".format(output_word))
                    return Judgement.WRONG_ANSWER
            else:
                # Just a regular(non-float) 'token'. Check if they're equal
                logging.debug("{} is not a float. Comparing characters".format(solution_word))

                if solution_word != output_word:
                    # Not equal. Wrong
                    logging.debug("{} != {}. Wrong".format(solution_word, output_word))
                    return Judgement.WRONG_ANSWER
                logging.debug("They're equal")

        solution_line = solution_output.readline()

    # Advance the user's output one more line to make sure it's EOF for them too
    output_line = program_output.readline()

    if output_line != "":
        # Still more user output. Wrong
        logging.info("User output too long. Manual validation failed")
        return Judgement.WRONG_ANSWER

    # Made it all the way out. Everything is validated
    logging.debug("Floating-point validation accepted!")
    return Judgement.ACCEPTED


if __name__ == "__main__":
    exit(main())
