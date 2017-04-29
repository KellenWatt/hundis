$files.keep_if do |f|
  f =~ $languages[:python3]
end

if !system("python -m py_compile *.py3")
  exit 1
else
  File.delete "__pycache__"
end

File.open(File.basename(Dir.pwd), "w+", 0755) do |out|
  out.puts "#!/usr/bin/env python3"
  combine out, $files
end
