# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   def self.escape_for_url(str)
     URI.escape(str, Regexp.new("[^-_!~*()a-zA-Z\\d]"))
  end
end
