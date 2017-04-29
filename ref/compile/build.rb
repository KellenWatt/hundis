
COMPILE_DIR = "#{ENV['HOME']}/bin/src/compile/lib"
EMPTY_MESS = "compile: Error: No accepted languages or makefile exist in this directory"
NONE_MESS = "compile: Error: No such compiler"

require "#{COMPILE_DIR}/.languages"

$exclusions.each do |e|
  if Dir.pwd =~ e
    puts "Directory cannot be compiled, due to its filepath matching \"#{e.source}\"."
    exit 1
  end
end

$files = Dir.entries(Dir.pwd).select do |f| 
  !File.directory?(f) && f[0] != "."
end

if ARGV[0] && $languages.keys.include?(ARGV[0].to_sym)
  puts NONE_MESS unless require "#{COMPILE_DIR}/#{ARGV[0]}"    
elsif $files.find {|f| f =~ /(M|R|m|r)akefile/}
  system("make") && exit($?.exitstatus)
  system("rake") && exit($?.exitstatus)
else
  max,$lang = 0,nil
  $languages.each do |l, reg|
    count = $files.count{ |f| f =~ reg }
    max,$lang = count,l if count > max
  end

  (puts(EMPTY_MESS) || exit(1)) if $lang == nil
  require "#{COMPILE_DIR}/#{$lang}"
end
