#!/usr/bin/env ruby
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'


def clean_zipcode(zip)
  zip.to_s.rjust(5, "0")[0..4]
end

def legislator_by(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    civic_info.representative_info_by_address(
          address: zipcode,
          levels: 'country',
          roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"
  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

template_letter = File.read("form_letter.html")
erb_template = ERB.new(template_letter)
content = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

content.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislator_by(zipcode)
  form_letter = erb_template.result(binding)
  save_thank_you_letters(id,form_letter)
end
