require 'digest'
require 'net/http'

password = ARGV.shift
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

