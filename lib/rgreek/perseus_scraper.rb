require "capybara"
require "capybara/dsl"
require "capybara-webkit" 
require "cgi"
module RGreek
class PerseusScraper
  include Capybara::DSL
  Capybara.run_server = false
  Capybara.current_driver = :webkit
  
  def self.perseus_data_for(lemma, &block)
    PerseusScraper.new.perseus_data_for(lemma, &block) #Capybara needs an instance not a class to work in
  end
  
  def perseus_data_for(lemma, &block)    
    visit morphology_url_for(lemma)
      map_each_lemma_table_in(page) do |lemma_table|
        lemma_data                = lemma_data_for(lemma_table)
        lemma_data[:morphologies] = morph_data_for(lemma_data[:morphologies])
        do_block(lemma, lemma_data[:short_def], lemma_data[:morphologies], block)      
      end
  end

private
  def do_block(lemma, short_def, parse_data, &block)
    case block.arity
      when 1 then yield lemma
      when 2 then yield lemma, short_def
      when 3 then yield lemma, short_def, parse_data
    else
      raise "Block requires one, two, or three arguments for: lemma, short_def, and parse_data"
    end
  end
  
  def morph_data_for(morphologies)
    morph_group = {}
    morph_data = []      
    morphologies.each do |morphology| 
      case morphology['class']
      when "token" #morph_code
        morph_group[morphology['class']] = morphology.text.lstrip.rstrip
      when "code"  #form
        morph_group[morphology['class']] = morphology.text.gsub("(NCA)", "").lstrip.rstrip
        morph_data << morph_group
        morph_group = {}
      end
    end
    morph_data
  end

  def map_each_lemma_table_in(page)
    Nokogiri::HTML(page.html).xpath("//table[contains(@class, 'lemmacontainer')]").map do |lemma_table|
      yield lemma_table
    end
  end

  def lemma_data_for(lemma_table)
    lemma_data = {}
    lemma_table             = Nokogiri::HTML(lemma_table.to_html) # we must do this or Noko will search the whole doc, not just the table
   #lemma_data[:headword]   = Transcoder.tonos_to_oxia lemma_table.xpath("//th[contains(@class,'lemma')]").text
    lemma_data[:short_def]  = Transcoder.tonos_to_oxia lemma_table.xpath("//th[contains(@class,'shortdef')]").text
    lemma_data[:parse_rows] = lemma_table.css("tr.parserow").children
    lemma_data
  end

  def morphology_url_for(lemma)
    escaped_greek_word = escape_headword(lemma.greek_headword)
    "http://perseus.uchicago.edu/perseus-cgi/morph.pl?token=#{escaped_greek_word}&lang=greek"
  end

  def escape_headword
    CGI.escape(Transcoder.oxia_to_tonos(lemma.greek_headword))
  end
end#EOC

module PerseusDataMethods
  def create_lemma(lemma, short_def, parse_data)
    parse_data.each do |parsing|
      lemma   =  Lemma.includes(:parses).find_or_create_by_headword_and_short_def(lemma.headword, short_def)
      parse =  Parse.find_or_create_by_morph_code_and_form(parsing["token"], parsing["code"])  
      lemma.parsings << parse
    end
  end
  
  def update_short_def(lemma, short_def)
    if ( lemma.short_def == nil || lemma.short_def.empty?) && short_def && !short_def.empty?
      lemma.short_def = short_def
      lemma.save
      puts lemma
    end
  end
end#EOM

end#EOM
