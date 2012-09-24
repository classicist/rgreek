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
    NO_OBJECTS_FOUND = "No Objects Found"
    MANY_OBJECTS_FOUND = 'Many Objects Found'
    
    FIRST_ENTRY = "http://artflx.uchicago.edu/cgi-bin/philologic/getobject.pl?c.1:1:0.LSJ"
    
    def self.get_first_entry
      get_entry get_url(FIRST_ENTRY)      
    end
 
    def self.get_next_entry(last_entry_url)
      last_entry = get_url(last_entry_url)
      next_entry_link = next_link(last_entry)
      if next_entry_link
        get_entry get_url(DOMAIN + next_entry_link)
      else
        nil
      end
    end
        
    def self.create_entry(entry_page)
      headword  = get_headword(entry_page)
      entry     = get_entry entry_page
      lsj = LsjEntry.create(headword: headword, entry: entry)
      lsj.save!
      lsj
    end
    
    def self.get_headword(entry)
      entry.css("span.head").text
    end
    
    def self.get_entry(entry_page)
      entry_page.css("div2").to_html
    end
    
    def self.next_link(entry)
      entry.traverse do |node|        
        if ['a'].include?(node.name) && node.text.include?("Next Entry")
          return next_entry_link = node['href'] 
        end        
      end
      return nil
    end
    
    def self.entry(unicode_headword)
       url = BASE + QUERY_STRING.gsub('ESCAPED_HEADWORD', CGI.escape(unicode_headword))
      response = get_url url
      entries    = response.css("#content a")

      if entries.length < 1
        raise "#{NO_OBJECTS_FOUND} for #{unicode_headword}" 
      elsif entries.length == 1
        single_dictionary_link = response.css("#content a")[0]['href']
        get_entry_from_page(single_dictionary_link)
      else
        raise "#{MANY_OBJECTS_FOUND} for #{unicode_headword}: #{response.to_html}"
      end
    end
    
    def get_entry_from_page(dictionary_link)
      entry_page = get_url DOMAIN + dictionary_link
      entry_page.css("div2").to_html      
    end
    
    def self.get_url(url)
      begin
        response = get(url)
        html = Nokogiri::HTML(response.body)
        html.css
        html
      rescue Exception => e
        raise "There was an error getting what you wanted:<br/> #{response} + #{e}"
      end
    end
  end#EOM  
end#EOM
