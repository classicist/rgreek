require 'spec_helper'

describe "MorphCode" do
    it "should translate the morph_code into english" do
    MorphCode.convert_to_english("v1spia---").should == "verb 1st sg pres ind act"
    MorphCode.convert_to_english("n-s---fn-").should == "noun sg fem nom"
    MorphCode.convert_to_english("c--------").should == "conj indeclinable"    
  end
end