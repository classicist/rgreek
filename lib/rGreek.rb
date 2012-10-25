require "active_record"
Dir[File.join(File.dirname(__FILE__), 'rgreek', '**/*.rb')].each { |file| require file.gsub(".rb", "")}

module RGreek
end
