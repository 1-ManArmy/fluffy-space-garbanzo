#!/usr/bin/env ruby

require 'net/http'
require 'uri'

def test_endpoint(url, name)
  begin
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    puts "#{name}: HTTP #{response.code} (#{response.message})"

    if response.code.to_i >= 500
      puts '  Error detected!'
      puts '  Contains NoMethodError' if response.body.include?('NoMethodError')
      puts '  Related to fallback attribute' if response.body.include?('fallback')
    else
      puts '  ✅ Success!'
    end
  rescue StandardError => e
    puts "#{name}: Connection failed - #{e.message}"
  end
  puts
end

# Test endpoints
puts 'Testing AI Agent Endpoints...'
puts '=' * 40

test_endpoint('http://localhost:3000/infoseek', 'InfoSeek')
test_endpoint('http://localhost:3000/datavision', 'DataVision')

puts 'Test completed!'
