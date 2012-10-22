require 'spec_helper'

module RGreek
  class StubParse
    extend Reflector
  end

  class StubLemma 
    extend Reflector
  end
  
  class StubConventionBreaker
    extend Reflector
    lemma_class :stub_lemma
  end
  
end

describe Reflector do  
  it "should reflect the lemma class of a parse by convention" do
    StubParse.lemma_class.should == StubLemma
  end
  
  it "should refelct the lemma class of a parse by configuration" do
    StubConventionBreaker.lemma_class.should == StubLemma
  end
  
  it "should reflect the plural parse class symbol of a lemma by convention" do
    StubLemma.parses_sym.should == :stub_parses
  end
  
  it "should reflect the singular lemma class symbol of a parse by convention" do
     StubParse.lemma_sym.should == :stub_lemma
  end
  
  it "should detect whether a parse or lemma is greek" do
    GreekLemma.new.is_greek?.should == true
    LatinLemma.new.is_greek?.should == false   
    
    GreekParse.new.is_greek?.should == true
    LatinParse.new.is_greek?.should == false   
  end
  
  it "should detect whether a parse or lemma is latin" do
    LatinLemma.new.is_latin?.should == true    
    GreekLemma.new.is_latin?.should == false        

    LatinParse.new.is_latin?.should == true    
    GreekParse.new.is_latin?.should == false     
  end
end