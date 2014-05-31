require 'sinatra'
set :public_folder, Proc.new { File.join root, "public"  }

get '/' do
  "Simple Sinatra assets server for local development"
end
