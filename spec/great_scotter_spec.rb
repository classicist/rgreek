# encoding: UTF-8

require "spec_helper"


describe "GreatScotter" do

before(:all) do
  @entry_page    = get_html_fixture(ENTRY_PAGE)
  @entry_url     = GreatScotter::FIRST_ENTRY
  @entry         = GreatScotter.get_entry get_html_fixture(ENTRY)
  @headword      = "Α α"
  @next_link     = "/cgi-bin/philologic/getobject.pl?c.1:1:1.LSJ"
  @entry_pattern = /^<div2.*<\/div2>$/m
  stub_in_filesystem_fixture_for_http
end
  it "should fake a url" do
    GreatScotter.get_url(@entry_url).to_html.should ==  @entry_page.to_html
  end
  
  it "should increment_url" do
    url = "/cgi-bin/philologic/getobject.pl?c.1:1:187.LSJ"
    GreatScotter.increment_minor_uri(url).should == "/cgi-bin/philologic/getobject.pl?c.1:2:0.LSJ"
    GreatScotter.increment_major_uri(url).should == "/cgi-bin/philologic/getobject.pl?c.2:1:0.LSJ"
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
end

FIXTURE_BY_URL = {GreatScotter::FIRST_ENTRY => ENTRY_PAGE}

def stub_in_filesystem_fixture_for_http
  GreatScotter.class_eval(%Q[
  def self.get_url(url)
    get_html_fixture FIXTURE_BY_URL[url]
  end
])
end

def should_be_an_lsj_entry(headword, entry)
   entry.should =~ @entry_pattern
   entry.should =~ /.*#{Regexp.escape(headword)}/
end
