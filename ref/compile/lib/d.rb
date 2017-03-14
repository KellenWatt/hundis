$files.keep_if do |f|
  f =~ $languages[:d]
end

system("gdc #{$files.join(" ")} -o #{File.basename(Dir.pwd)}")
