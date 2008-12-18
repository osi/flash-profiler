#!/usr/bin/env ruby -wKU
# 
# Launch the profiler console
#
# Liberally borrowed from the rails console.rb
#
#
irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'

require 'optparse'

options = { :irb => irb, :port => 42624 }

OptionParser.new do |opt|
  opt.banner = "Usage: console.rb [options]"
  opt.on("-p", "--port=[#{options[:port]}]", 'Port to listen on (TODO make this changable :)') { |v| options[:port] = v }
  opt.on("--irb=[#{irb}]", 'Invoke a different irb.') { |v| options[:irb] = v }
  opt.parse!(ARGV)
end

libs =  " -r irb/completion"
libs << " -r flash_profiler/server.rb"

exec "#{options[:irb]} #{libs} --readline "
