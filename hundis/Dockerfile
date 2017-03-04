FROM ubuntu:14.04
# include/install the list of allowed languages here
# C/C++, Java, Python3, D, Go, Ruby, C#, Pascal, Javascript, Scala, PHP, Haskell, Lua, 
# clisp/scheme
RUN apt-get update
RUN apt-get upgrade

# NOTE: Any of these may need to be installed from source if necessary
#       Checks will need to be performed if a switch is made

RUN apt-get -y install g++                  # C/C++
RUN apt-get -y install python3              # Python 3 (Python 2 on request)
RUN apt-get -y install dmd                  # Dlang (switch if Grayson objects)
RUN apt-get -y install golang               # Golang
RUN apt-get -y install ruby2.3              # Ruby 2.3
RUN apt-get -y install mono-devel           # C#
RUN apt-get -y install fp-compiler          # Free Pascal
RUN apt-get -y install nodejs               # JavaScript, may need to find less robust version
RUN apt-get -y install scala                # Scala
RUN apt-get -y install php5-cli             # PHP - without server
RUN apt-get -y install haskell-platform     # Haskell
RUN apt-get -y install lua5.2               # Lua
RUN apt-get -y install sbcl                 # Stone Beach Common Lisp

# install grading mechanism here, may just be mounted file


# create and set the user
RUN useradd -m -s /bin/bash jjeuser
USER jjeuser
WORKDIR /home/jjeuser

# retrieve the code/output to be graded
# should be implicitly done with a mounted filesystem between the host and the container


# run the grading mechanism on the input files and code
CMD "grader" && exit $?
# NOTE: This is not an ENTRYPOINT so that the container can still be accessed 
# in case of debugging

# clean up changes made to the system by execution and grading, if any
# Just delete the container so it doesn't matter

# return success or failure to host, should be implicit from script


#####
# Single image for all purposes, spin up new container per submission
#   Have to check this with benchmark testing. May not be very fast to generate every time. 
#####
