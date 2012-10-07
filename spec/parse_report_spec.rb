# encoding: UTF-8
require 'spec_helper'

describe ParseReport do
  it "should create a ParseReport for a word form" do
    reports = ParseReport.generate("kai/")
    reports.first.lemma.should == Lemma.find_by_headword("kai/")
    reports.first.parses.should == Parse.find_parses("kai/")
    reports.first.to_s.should  == "καί: and, conj indeclinable"
  end
  
end