require "xmlrpc/client"
require "json"
#http://archimedes.mpiwg-berlin.mpg.de/arch/doc/xml-rpc.html

module RGreek
  module Archimedes
    class << self
    SERVER = XMLRPC::Client.new( "archimedes.mpiwg-berlin.mpg.de","/RPC2","8098");
    def greek_lemma(betacode)
      lemma(betacode, "-GRC")
    end
    
    def latin_lemma(word)
      lemma(word, "-L")
    end

private    
    def lemma(word, lang_flag)
      JSON.parse server.call('lemma', lang_flag, [word], 'full')
    end
  end#EOCM
  end#EOARCH
end#EOM