$files.keep_if do |f|
  f =~ $languages[:assembly]
end

$files.each do |f|
  if !system("nasm -f elf64 #{f}")
    exit $?.exitstatus
  end
end

if !system("ld -o #{File.basename(Dir.pwd)} *.o")
  exit $?.exitstatus
else
  Dir.glob("*.o").each do |f|
    File.delete f
  end
end
