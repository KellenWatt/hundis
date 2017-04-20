$files.keep_if do |f|
  f =~ $languages[:java]
end

system("javac #{$files.join " "}")
