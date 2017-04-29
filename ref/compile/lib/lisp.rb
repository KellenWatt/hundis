$files.keep_if do |f|
  f =~ $languages[:lisp]
end

$files.each do |f|
  if !system("clisp -q -c #{f}")
    exit $?.exitstatus
  end
end

File.open(File.basename(Dir.pwd), "w+", 0755) do |out|
  out.puts "#!#{`which clisp`}"
  combine out, $files
end
