require "httparty"
require 'cgi'
require 'nokogiri'
module RGreek
  module GreatScotter
    include HTTParty
    format :html
    DOMAIN = "http://artflx.uchicago.edu"
    BASE = "#{DOMAIN}/cgi-bin/philologic/search3torth"
    QUERY_STRING = "?dbname=LSJ&ORTHMODE=accented&dgdivhead=ESCAPED_HEADWORD&matchtype=exact&word=&CONJUNCT=PHRASE"
    
    def self.entry(unicode_headword)
       url = BASE + QUERY_STRING.gsub('ESCAPED_HEADWORD', CGI.escape(unicode_headword))
      response = get_url url
      dictionary_link = response.css("#content a")[0]['href']
      
      entry_page = get_url DOMAIN + dictionary_link
      entry_page.css("div2").to_html
    end
    
    def self.get_url(url)
      begin
        response = get url
        text = Nokogiri::HTML(response.body)
      rescue Exception => e
        "There was an error getting what you wanted:<br/> #{e}"
      end
    end
  end#EOM  
end#EOM
