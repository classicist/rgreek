# RGreek

This is the first and only set of tools for working with classical Greek in the Ruby language. They are meant to be 
straight-forward, lightweight, and comprehensive within their scope.

That said this is a work-in-progress and this toolset will continue to grow along with my need of them. I am definitely 
scratching my own itch here.

If you have any problems with the tools or would like them extended, please feel free to write a failing spec and send me a  
pull request. I am working on this project semi-actively at the moment and would be happy to fix it. 

## Installation

Add this line to your application's Gemfile:

    gem 'rGreek'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rGreek

## Usage

### RGreek::Transcoder
This module converts greek text between bi-directionally betacode and unicode (Pre-combined Unicode C, specifically)
To convert any amount of text (that will fit in your machine's memory) simply do:

RGreek::Transcoder.convert(kai/) # =>  καί
RGreek::Transcoder.convert(καί)  # =>  kai/

Caveat Emptor:
The Transcoder understands the full betacode spec and can convert seamlessly between unicode and betacode, however,
although the Transcoder will convert the rarely used betacode symbol "s2" for final sigma into unicode, it does will
ever generate this symbol when converting unicode to betacode. This is simply because it is hard for humans to read. 
Further, this is the behavior of all other major transcoders (such as Perseus and the TLG) -- it is trivial to detect
whether a sigma is final or not. Also, the Transcoder encodes acute accents to oxia, not tonos. 

RGreek::Transcoder.tonos_to_oxia(unicode)
RGreek::Transcoder.oxia_to_tonos(unicode)

Since there are two ways in this great, wide, world to encode an acute accent in Greek, the tonos (designed for modern Greek) and the oxia (designed for polytonic greek) one sometimes needs a way to convert between them. People don't alway encode their data correctly, you know (looking at you Chicago). These methods serve that end and cover all the cases of pre-combined accents including a tonos or oxia I could find in the unicode spec. These methods take a string of any length and just ignore non-tonos/oxia chars.

RGreek::Transcoder.is_betacode?(text)
RGreek::Transcoder.is_unicode?(text)

These should be obvious.

RGreek::Transcoder.name_of_unicode_char(c)

In the case that you need to inspect some text to know what sort of encodings or characters your dealing with (and are sick of writing the same regexs over and over again), this translates the character into an english-named token. It exists so you can easily see what you've got on your hands.

RGreek::Transcoder.tokenize(betacode)

Finally, although this is a private method, if you are interested (or having problems with) the tokenization of betacode in some corner not covered by the specs, this is where the heavy lifting happens

### RGreek::MorphCode
RGreek::MorphCode.convert_to_english(code)

This converts the morphology code strings in the Perseus project database into readable english

### RGreek::MonkeyPatches
Debugging programming in Greek can be a real pain, so to aid in that endever rgreek adds a method to String, which translates its characters into the proper the hex representation of their unicode code points so they can be clearly seen, understood, and looked up. Ruby 1.9.3 defaults to (unhelpfully) giving the code points in decimal.

"καί".to_unicode_points # => ["03f0", "03b1", "1f77"]

### RGreek::Archimedes

RGreek::Archimedes.greek_lemma(kai/) # => {"lu/w" => ["indecl"]}
RGreek::Archimedes.latin_lemma(sed)  # => {"sed" => ["indecl"]}

These are a web-client to the Archimedes service, which is built on top of the Perseus Project parse and lemma data for greek and latin words. These methods take inflected forms of words and return a hash of possible lemmas they belong to and an array of possible parsings

### Other Things...
The rest, well, is shall we say, stil under development for a still secret, but hopefully more exciting project. In the mean time, enjoy the tools!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
