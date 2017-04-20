$files.keep_if do |f|
  f =~ $languages[:go]
end

system("go build")
