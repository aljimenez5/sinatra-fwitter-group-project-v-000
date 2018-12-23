class UsersController < ApplicationController

  get '/signup' do
    if Helpers.logged_in?(session)
      redirect to "/tweets"
    else
      erb :"/users/create_user" 
    end
  end

  post '/signup' do
    if params.values.any? &:empty?
      redirect "/signup"
    else
      @user = User.find_by(username: params[:username], email: params[:email], password_digest: params[:password]) || @user = User.create(params)
      session[:user_id] = @user.id
      redirect "/tweets"
    end

  end

  get '/login' do
    if Helpers.logged_in?(session)
      redirect to "/tweets"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/tweets"
    else
      redirect to "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect to "/login"
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @tweets = @user.tweets
    erb :"/users/show"
  end




end
