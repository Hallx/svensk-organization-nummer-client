require 'rubygems'
require 'bundler/setup'
Bundler.require

begin
  unless ARGV.size > 0
    puts "Usage: #ruby client.rb company_name"
    exit
  end
  search_string = ARGV.join(" ")
  uri_parameter = URI.escape(search_string.split.join("+"))

  server_response = RestClient.get "localhost:3000/companies/search?search_string=#{uri_parameter}", :accept => 'application/json'
  matches = JSON.parse(server_response)
  
  if matches.empty?
    puts "No such company found!" 
    exit
  end 
  
  first_match = matches.first
  if (search_string.downcase == first_match["name"].downcase)
    puts "Company name: #{first_match["name"]}"
    puts "Ogranization number: #{first_match["organization_number"]}"
  else
    puts "Exact name not found."
    puts "\n"
    puts "Companies with similar name are:"
    for match in matches
      puts "#{match['organization_number']}\t\t#{match['name']}"
    end    
  end  
rescue Errno::ECONNREFUSED
  puts "please run the server first."
  exit
end
