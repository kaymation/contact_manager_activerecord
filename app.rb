require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"


require_relative 'models/contact'
also_reload 'models/contact'


get '/' do
  redirect '/contacts'
end

get '/contacts' do
  @page_no = params["page"].to_i
  @page_no = 1 if @page_no == 0
  offset = 3*(@page_no - 1)
  @contacts = Contact.all.limit(3).offset(offset)
  erb :index
end

get '/contacts/search' do
  @query = params["Box"]
  @contacts = Contact.where('first_name ILIKE ? or last_name ILIKE ?', "%#{@query}%", "%#{@query}%")
  erb :index
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id])
  erb :show
end

post '/contacts' do
  unless [params["first_name"], params["last_name"], params["phone_number"]].include?("")
    Contact.create(params)
  end
  redirect '/contacts'
end
