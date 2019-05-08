require "bundler/gem_tasks"

desc 'Generate the language database script.'
task :generate do

  regex = /^(?<p3>[a-z]{3})\t(?<p2b>[a-z]{3})?\t(?<p2t>[a-z]{3})?\t(?<p1>[a-z]{2})?\t[A-Z]\t[A-Z]\t(?<name>.+)(\t*+)?$/
  i = 0

  src = File.join(__dir__, 'iso-639-3.tab')
  dest = File.join(__dir__, 'lib', 'subs', 'language_database.rb')

  Rake::Task[:download].execute unless File.exist?(src)

  puts 'Generating languages...'

  File.open(dest, 'wb') do |io|

    io.puts 'module Subs'
    io.puts '  class Language'
    io.puts '    def self.database'
    io.puts '      @database ||= Set['

    File.open(src, 'rb').each_line do |line|


      match = regex.match(line)
      next unless match
      match = match.names.map(&:to_sym).zip(match.captures).to_h

      args = [
          match[:name].chomp.strip,
          match[:p3],
          match[:p2b] ? ":#{match[:p2b]}" : 'nil',
          match[:p2t] ? ":#{match[:p2t]}" : 'nil',
          match[:p1] ? ":#{match[:p1]}" : 'nil'
      ]

      io << ",\n" unless i.zero?
      io << format("        Language.new(\"%s\", :%s, %s, %s, %s)", *args)
      i += 1
    end
    io.puts
    io.puts '      ]'
    io.puts '    end'
    io.puts '  end'
    io.puts 'end'
  end

  puts "Generated #{i} languages."
  puts 'Done.'
end

desc 'Download ISO-639 language definition'
task :download do

  require 'open-uri'
  puts 'Fetching ISO-639 language definitions...'
  open('https://iso639-3.sil.org/sites/iso639-3/files/downloads/iso-639-3.tab') do |src|
    File.open('./iso-639-3.tab', 'wb') { |io| io.write(src.read) }
  end
  puts 'Done.'
end


task :default => :generate
