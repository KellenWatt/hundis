$files.keep_if do |f|
  f =~ /\.c(pp)?$/
end

COMPILE_STRING ="g++ -std=c++11 -Wall -W -s -pedantic-errors -lpthread -o"

system("#{COMPILE_STRING} #{File.basename(Dir.pwd)} #{$files.join(" ")}")
