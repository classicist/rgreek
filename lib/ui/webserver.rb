$LOAD_PATH.push File.expand_path("../../", __FILE__)

require "sinatra"
require 'haml'
require 'rgreek'
  include RGreek

get "/" do
  haml :index  
end

post "/" do
  @report = ParseReport.generate(params[:parse])
  haml :show  
end

__END__
@@index
%form{ :action => "", :method => "post"}
  %fieldset
    %ol
      %li
        %label{:for => "parse"} Parse:
        %input{:type => "text", :name => "parse", :class => "text"}
    %input{:type => "submit", :value => "Send", :class => "button"}

@@show
%div
  - @report.each do |parse|
    = parse.to_s + "<br/>"

  