# encoding: UTF-8

require 'spec_helper'

describe "Monkey Patches" do
  it "should add a to_unicode_points method to String" do
    "hello unicode".should respond_to(:to_unicode_points)
  end
  
  it "should give the unicode code points for each character in a string" do
    "ab".to_unicode_points.should == ["0061", "0062"]
    tonos = "ί"
    tonos.to_unicode_points.should == ["03af"]
    oxia = "ί"
    oxia.to_unicode_points.should == ["1f77"]    
  end
end