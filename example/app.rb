require 'bundler'
Bundler.setup :example
require 'sinatra'

get '/' do
  content_type 'image/jpeg'
  send_file File.expand_path('../data/a.jpg', __FILE__)
end

def fat_data
  @data ||= open(File.expand_path('../data/a.jpg', __FILE__)).read
end
