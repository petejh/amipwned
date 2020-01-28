require 'digest'
require 'io/console'
require 'net/http'
require 'optparse'

VERSION = '0.2.0'

class CommandParser
  class Options
    attr_accessor :password
  end

  class << self
    def parse(args)
      @options = Options.new
      option_parser.parse! args
      @options
    end

    def option_parser
      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: ruby amipwned.rb [options]"

        opts.on('-p PASSWORD', '--password', 'Password to check') do |password|
          @options.password = password
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Print version') do
          puts VERSION
          exit
        end
      end
    end
  end
end

def prompt_for_password
  IO.console.getpass "Enter a password to check: "
end

options = CommandParser.parse ARGV
password = options.password || prompt_for_password

password_hash = Digest::SHA1.hexdigest(password).upcase

head = password_hash[0..4]
tail = password_hash[5..-1]

uri = URI("https://api.pwnedpasswords.com/range/#{head}")
response = Net::HTTP.get_response(uri)

puts "server responded: #{response.code}"
response.body.each_line do |line|
  hash, count = line.chomp.split(':')
  puts "#{password} was found #{count} times!" if hash == tail
end

