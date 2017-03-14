require_relative ".languages"

$files.keep_if do |f|
  f =~ $languages[:ruby]
end

if !system("ruby -wc *.rb > /dev/null")
  exit $?.exitstatus
end


File.open(File.basename(Dir.pwd), "w+", 0755) do |out|
  out.puts "#!/usr/bin/env ruby"
  combine out, $files
end

