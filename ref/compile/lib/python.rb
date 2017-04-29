$files.keep_if do |f|
  f =~ $languages[:python]
end

if !system("python -m py_compile *.py")
  exit 1
else
  Dir.glob("*.pyc").each do |f|
    File.delete(f)
  end
end

File.open(File.basename(Dir.pwd), "w+", 0755) do |out|
  out.puts "#!/usr/bin/env python"
  combine out, $files
end
