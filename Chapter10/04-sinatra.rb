require 'sinatra'

get "/" do
  "Index page"
end

not_found do
 "File Not Found"
end

module Sinatra::Delegator
  meths = %i[get not_found] # ...

  meths.each do |meth|
    define_method(meth) do |*args, &block|
      Sinatra::Application.send(meth, *args, &block)
    end
  end
end

extend Sinatra::Delegator
