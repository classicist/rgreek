# encoding: UTF-8

require "spec_helper"


describe "GreatScotter" do

before(:all) do
  @entry_page    = get_html_fixture(ENTRY_PAGE)
  @entry         = GreatScotter.get_entry get_html_fixture(ENTRY)
  @headword      = "Α α"
  @next_link     = "/cgi-bin/philologic/getobject.pl?c.1:1:1.LSJ"
  @entry_pattern = /^<div2.*<\/div2>$/m
end

  it "should get the headword of an lsj entry" do
    GreatScotter.get_headword(@entry_page).should == @headword
  end

  it "should create an lsj entry" do
    lsg_entry = GreatScotter.create_entry(@entry_page)
    lsg_entry.headword.should == @headword
    lsg_entry.entry.should == @entry
  end

  it "should should find the link for the next entry" do
    GreatScotter.next_link(@entry_page).should == @next_link
  end

  it "should get the first entry in lsj" do
    entry = GreatScotter.get_first_entry
    entry.should =~ @entry_pattern
  end
  
  it "should get the next entry in lsj" do
    entry = GreatScotter.get_next_entry(GreatScotter::FIRST_ENTRY)
    entry.should =~ @entry_pattern   
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
   entry.should =~ @entry_pattern
   entry.should =~ /.*#{Regexp.escape(headword)}/
end
