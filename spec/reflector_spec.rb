require 'spec_helper'

module RGreek
  class StubParse
    extend Reflector
  end

  class StubLemma 
  end
  
  class StubConventionBreaker
    extend Reflector
    lemma_class :stub_lemma
  end
  
end

describe Reflector do  
  it "should reflect the correct class by convention" do
    StubParse.lemma_class.should == StubLemma
  end
  
  it "should refelct the correct class by configuration" do
    StubConventionBreaker.lemma_class.should == StubLemma
  end
end