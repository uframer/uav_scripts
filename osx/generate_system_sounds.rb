#!/usr/bin/ruby

def usage()
  printf "Usage:\n\t#{$PROGRAM_NAME} <input_file>\n"
end

if ARGV.size != 1 then
  usage()
  exit 1
end

input_filename = ARGV[0]
output_filename = ARGV[0] + ".enum"

voice="Samantha"

`rm -f #{output_filename}`
`rm *.wav`
File.open(output_filename, "w") do |output|
  count = 0
  output.puts "enum phrase_name {"
  File.open(ARGV[0],"r") do |input|
    while line = input.gets
      line = line.chomp
      index = line.index(',')
      phrase_name = line[0, index].upcase
      phrase_content = line[index + 1, line.size]
      `say -v #{voice} -o #{phrase_name}.aiff #{phrase_content}`
      `ffmpeg -i #{phrase_name}.aiff #{phrase_name}.wav > /dev/null 2>&1`
      `rm #{phrase_name}.aiff`
      output.puts "    #{phrase_name} = #{count},"
      count += 1
    end
  end
  output.puts "    PHRASE_NAME_END\n}"
end
`rm *.aiff`
