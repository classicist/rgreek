# encoding: UTF-8
require "spec_helper"

describe "rGreek" do
  it "should do exist" do
    Lemma.new.should_not be_nil
    Parse.new.should_not be_nil    
  end
end