require 'digest'
require 'io/console'
require 'net/http'
require 'optparse'

def prompt_for_password
  IO.console.getpass "Enter a password to check: "
end

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby amipwned.rb [options]"

  opts.on('-pPASSWORD', '--password=PASSWORD', 'Password to check') do |password|
    options[:password] = password
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end

option_parser.parse!

password = options[:password] || prompt_for_password

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

