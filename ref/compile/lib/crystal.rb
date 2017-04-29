require_relative ".languages"

$files.keep_if do |f|
  f =~ $languages[:crystal]
end

system("crystal build *.cr")
