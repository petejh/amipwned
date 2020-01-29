require 'digest'
require 'io/console'
require 'net/http'
require 'optparse'

module AmIPwned
  VERSION = '0.2.0'

  class CommandParser
    class CommandOptions
      attr_accessor :password
    end

    class << self
      def parse(args)
        @options = CommandOptions.new
        option_parser.parse! args
        @options
      end

      def option_parser
        @parser = OptionParser.new do |opts|
          program_name = File.basename($PROGRAM_NAME)

          opts.banner = <<~BANNER
            Usage: ruby #{program_name} [options]

            Validate a given password against a public database of known data breaches.

            By default, the program will prompt for a password to test, although you
            may supply one on the command line if you are not concerned about leaking
            secrets into the command history log. The password is never otherwise saved
            to persistent storage.

            Using a k-anonymity model, only a short prefix of the hashed password is
            shared with the database. The database service never gains enough information
            about the password to be able to exploit it later.
          BANNER
          opts.separator ''

          opts.separator 'Options:'
          opts.on( '-p PASSWORD', '--password',
                   'Password to validate against data breaches') do |password|
            @options.password = password
          end

          opts.separator ''
          opts.on_tail('-h', '--help', 'Display this help and exit') do
            puts opts
            exit
          end

          opts.on_tail('-v', '--version', 'Print version information and exit') do
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
end
