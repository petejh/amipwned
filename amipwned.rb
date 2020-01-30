require 'digest'
require 'io/console'
require 'net/http'
require 'optparse'

module AmIPwned
  VERSION = '0.3.0'

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

  module PwnedPasswords
    PREFIX_LENGTH = 5

    class Password
      def initialize(password)
        @hashed = hash(password)
      end

      def pwned?
        pwned_count > 0
      end

      def pwned_count
        APIv2.potential_matches(head)[tail]
      end

      private
      attr_reader :hashed

      def hash(password)
        Digest::SHA1.hexdigest(password).upcase
      end

      def head
        hashed[0..(PREFIX_LENGTH - 1)]
      end

      def tail
        hashed[PREFIX_LENGTH..-1]
      end
    end

    class APIv2
      API_BASE_URL = "https://api.pwnedpasswords.com"

      class << self
        def potential_matches(partial_hash)
          query_range(partial_hash).map { |line| line.split(':') }.to_h
        end

        private

        def query_range(partial_hash)
          uri = URI("#{API_BASE_URL}/range/#{partial_hash}")

          response = Net::HTTP.get_response(uri)

          response.body.lines(chomp: true)
        end
      end
    end
  end

  def prompt_for_password
    IO.console.getpass "Enter a password to check: "
  end

  options = CommandParser.parse ARGV
  password = options.password || prompt_for_password
  hashed_password = PwnedPasswords::Password.new(password)

  puts "#{password} was found #{hashed_password.pwned_count || 0} times!"
end
