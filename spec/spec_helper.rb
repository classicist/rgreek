$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
ENV["RGREEK_ENV"] = "test"

require 'nokogiri'
require "nokogiri/diff"
require 'equivalent-xml'

require 'rgreek'
  include RGreek
  
ENTRY_PAGE  = "chicago_lsj_entry_page.html"
ENTRY       = "chicago_lsj_entry.html"
NO_ENTRY    = "null_fixture.html"
NO_ENTRY_URL   = "fail.com"

def get_html_fixture(filename)
  root = File.expand_path(File.dirname(__FILE__))
  Nokogiri::HTML(File.read(File.join(root, "fixtures/#{filename}")))
end

def xml_should_be_equal(left, right, opts = {:element_order => true, :normalize_whitespace => true})
  equal = EquivalentXml.equivalent?(left, right, opts)
  if equal
    equal.should be_true #asserting the tautology just lets rspec know a test ran
  else
    diff = "Diff: \n"
    left.diff(right) do |change, node| 
      diff += change.gsub(/[^+-]/m, "") + node.to_html.ljust(30) + " --" + node.path + "\n" if /^[+-].*/ =~ change 
    end
    fail diff  
  end    
end