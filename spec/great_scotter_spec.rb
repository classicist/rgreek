# encoding: UTF-8

require "spec_helper"


describe "GreatScotter" do

  it "should should find the link for the next entry" do
    @entry ||= get_html_fixture(NEXT_ENTRY)
    GreatScotter.next_link(@entry).should == "/cgi-bin/philologic/getobject.pl?c.1:1:1.LSJ"
  end

  it "should get the first entry in lsj" do
    entry = GreatScotter.get_first_entry
    entry.should =~ /^<div2.*<\/div2>$/m
  end
  
  it "should get the next entry in lsj" do
    entry = GreatScotter.get_next_entry(GreatScotter::FIRST_ENTRY)
    entry.should =~ /^<div2.*<\/div2>$/m    
  end
  
  it "should get multiple entries for a single word" do
    pending
    headword = "λέγω"
    should_be_an_lsj_entry headword, GreatScotter.entry(headword)
  end
  
  it "should should find nothing" do
    pending
    headword = "alkajsdfj"
    GreatScotter.entry(headword).should == GreatScotter::NO_OBJECTS_FOUND
  end
  
  it "should get an entry by its headword" do
    pending
    headword = "πῶς"
    should_be_an_lsj_entry headword, GreatScotter.entry(headword)
  end
end

def should_be_an_lsj_entry(headword, entry)
   entry.should =~ /^<div2.*<\/div2>$/m
   entry.should =~ /.*#{Regexp.escape(headword)}/
end
