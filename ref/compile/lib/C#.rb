$files.keep_if do |f|
  f =~ $languages[:"C#"]
end

system("mcs #{$files.join(" ")}")
