# Initializer for the docker sandboxes. 
# Builds a new image from the Dockerfile and tags it :latest
require 'docker'

image = Docker::Image.build_from_dir('.')
image.insert_local('localPath' => 'grader.py', 'outputPath' => '/home/jjeuser'
image.tag('repo' => 'jje_sandbox', 'tag' => 'latest', force: true)
