$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'nokogiri'
require "nokogiri/diff"
require 'equivalent-xml'

require 'rgreek'
  include RGreek
  
def get_entry_fixture(safe_headword)
  root = File.expand_path(File.dirname(__FILE__))
  File.read(File.join(root, "fixtures/lsj_#{safe_headword}_entry.html"))
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