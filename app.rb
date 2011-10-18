# encoding: UTF-8

require 'sinatra'
require 'sinatra/activerecord'
require 'alphadecimal'

class ShortenedUrl < ActiveRecord::Base
  validates_uniqueness_of :url
  validates_presence_of :url
  validates_format_of :url, :with => /^\b((?:https?:\/\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))$/

  def shorten
    self.id.alphadecimal
  end

  def self.find_by_shortened(shortened)
    find(shortened.alphadecimal)
  end
end

get '/' do
  haml :index
end

post '/' do
  @short_url = ShortenedUrl.find_or_create_by_url(params[:url])
  haml :index
end

get '/:shortened' do
  short_url = ShortenedUrl.find_by_shortened(params[:shortened])
  redirect short_url.url
end
