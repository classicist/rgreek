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
  
  it "should reflect the parse class symbol of a lemma by convention" do
    StubLemma.to_parse_sym.should == :stub_parse
  end
end