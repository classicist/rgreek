# encoding: UTF-8
require 'spec_helper'

describe ParseReport do
  it "should create a ParseReport for a word form" do
    reports = ParseReport.generate("kai/", GreekParse)
    reports.first.lemma.should == GreekLemma.find_by_headword("kai/")
    reports.first.parses.should == GreekParse.find_parses("kai/")
    reports.first.to_s.should  == "καί: and, conj indeclinable"
  end
  
end