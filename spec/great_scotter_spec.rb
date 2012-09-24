# encoding: UTF-8

require "spec_helper"


describe "GreatScotter" do
  it "should get an entry by its headword" do
    headword = "πῶς"
    should_be_an_lsj_entry headword, GreatScotter.entry(headword)
  end
end

def should_be_an_lsj_entry(headword, entry)
   entry.should =~ /^<div2.*<\/div2>$/m
   entry.should =~ /.*#{Regexp.escape(headword)}/
end
