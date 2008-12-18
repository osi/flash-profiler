#!/usr/bin/env ruby -wKU
# 
# Launch the profiler console
#
# Liberally borrowed from the rails console.rb
#
#
irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'

require 'optparse'

options = { :irb => irb }

OptionParser.new do |opt|
  opt.banner = "Usage: console.rb [options]"
  # opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
  opt.on("--irb=[#{irb}]", 'Invoke a different irb.') { |v| options[:irb] = v }
  opt.parse!(ARGV)
end

libs =  " -r irb/completion"
# libs << " -r #{RAILS_ROOT}/config/environment"
# libs << " -r console_app"
# libs << " -r console_with_helpers"

exec "#{options[:irb]} #{libs} --readline"
