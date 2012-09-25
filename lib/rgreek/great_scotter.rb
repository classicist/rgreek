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
    START = Time.now    
    BIG = 0
    MEDIUM = 1
    SMALL = 2    
    
    def self.get_first_entry
      get_entry get_url(FIRST_ENTRY)      
    end
 
    def self.get_page(link)
       get_url(DOMAIN + link)
    end
        
    def self.get_all_entries
      puts "Starting attempt to get_all_entries at #{START}"
      most_recent_url = FIRST_ENTRY 
      link_to_next_entry = most_recent_url 
      
      while link_to_next_entry
        last_working_url = get_dictionary_secion(link_to_next_entry)
        link_to_next_entry = increment_url(last_working_url)
      end
    end
    
    def self.increment_url(last_working_url)
      minor = increment_minor_uri(last_working_url)
      major = increment_major_uri(last_working_url)
     
      if has_headword?(minor)
        puts "incementing minor to: #{minor}"
        minor
      elsif has_headword?(major)
        puts "incementing major to: #{major}"        
        major
      else
        nil
      end
    end
    
    def self.has_headword?(url)
      h = get_headword( get_page(url) )
      puts "headword test: #{h}"
      h != nil && h != ""
    end
    
    def self.increment_major_uri(url)
      incrementor(url) do |text_uri|        
        text_uri[BIG] = (text_uri[BIG].to_i + 1).to_s
        text_uri[MEDIUM]  = 1
        text_uri[SMALL]  = 0
      end
    end
    
    def self.increment_minor_uri(url)
      incrementor(url) do |text_uri|
        text_uri[MEDIUM] = (text_uri[MEDIUM].to_i + 1).to_s
        text_uri[SMALL]  = 0      
      end
    end
    
    def self.incrementor(last_working_url)
      base     = last_working_url.split("?c.").first + "?c."
      text_uri = last_working_url.split("?c.").last
      text_uri = text_uri.gsub(".LSJ", "")            
      text_uri = text_uri.split(":") 
      yield text_uri
      base + text_uri.join(":") + ".LSJ"     
    end
    
    def self.get_dictionary_secion(link_to_next_entry)
      while link_to_next_entry
        last_working_url = link_to_next_entry
        puts "Trying: #{link_to_next_entry}..."
        next_entry_page = get_page(link_to_next_entry)
        lsj_entry = create_entry(next_entry_page)
        puts "Successfully Created: #{lsj_entry.headword}, #{Time.now - START} elapsed"
        link_to_next_entry = next_link(next_entry_page)
      end
      last_working_url
    end
        
    def self.create_entry(entry_page)
      headword  = get_headword(entry_page)
      entry     = get_entry entry_page
      lsj = LsjEntry.create(headword: headword, entry: entry)
      lsj.save!
      lsj
    end
    
    def self.get_headword(entry_page)
      entry_page.css("span.head").text
    end
    
    def self.get_entry(entry_page)
      entry_page.css("div2").to_html
    end
    
    def self.next_link(entry_page)
      entry_page.traverse do |node|        
        if ['a'].include?(node.name) && node.text.include?("Next Entry")
          return next_entry_link = node['href'] 
        end        
      end
      return nil
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
        raise "There was an error getting what you wanted from #{url} :#{response} + #{e}"
      end
    end
  end#EOM  
end#EOM


## Failed, if insctuctive attempt:
## there is some problem with chicago's website that prevents searching by unicode headword
## in fact even transliteration searches are spotty
## if it works in the future, this code will also work
#   def self.entry(unicode_headword)
#      url = BASE + QUERY_STRING.gsub('ESCAPED_HEADWORD', CGI.escape(unicode_headword))
#     response = get_url url
#     entries    = response.css("#content a")
#
#     if entries.length < 1
#       raise "#{NO_OBJECTS_FOUND} for #{unicode_headword}" 
#     elsif entries.length == 1
#       single_dictionary_link = response.css("#content a")[0]['href']
#       get_entry_from_page(single_dictionary_link)
#     else
#       raise "#{MANY_OBJECTS_FOUND} for #{unicode_headword}: #{response.to_html}"
#     end
#   end
