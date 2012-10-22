module RGreek
  module LanguageDelegator
            
    def self.extended(base)
     @base = base
  end
            
  def self.method_missing(meth, *args, &block)
   puts "moo"
    super(meth, args, &block) unless args.length == 1
    @base.send(meth, args, &block)
  end

  end#EOM
end#EOM