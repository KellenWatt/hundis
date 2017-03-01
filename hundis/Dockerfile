FROM ubuntu:14.04
# include/install the list of allowed languages here


# install grading mechanism here


# create and set the user
RUN useradd -m -s /bin/bash jjeuser
USER jjeuser
WORKDIR /home/jjeuser

# retrieve the code/output to be graded
# This should be put inside a specific folder in the container by the host
#     Can either place in directory or communicate with bridge on host


# run the grading mechanism on the retrieved files


# return success or failure to host



#####
# Clarify:
# Should we build a single image that runs everything, or build a new image for submission?
# Should be build a bunch of containers or create a new one per submission.
#   Have to check this with benchmark testing. May not be very fast to generate every time. 
#####
