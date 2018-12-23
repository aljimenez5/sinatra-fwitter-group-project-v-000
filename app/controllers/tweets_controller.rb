class TweetsController < ApplicationController

  get '/tweets' do

    @tweets = Tweet.all

    erb :'/tweets/tweets'
  end

  get '/tweets/new' do
    erb :'/tweets/new'
  end

  post '/tweets' do
    user = User.find_by(id: session[:user_id])
    tweet = Tweet.create(content: params[:content])
    user.tweets << tweet

    redirect to '/tweets/#{tweet.id}'
  end

  get '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])
    erb :'/tweets/show_tweet'
  end

  get '/tweets/:id/edit' do
    if Helpers.logged_in?(session)
      if params[:id].to_i == session[:user_id]
        @tweet = Tweet.find_by(id: params[:id])
        erb :'/tweets/edit_tweet'
      else
        redirect to "/tweets"
      end
    else
      redirect to "/login"
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])
    if !params[:content].empty?
      @tweet.update(content: params[:content])
      redirect to '/tweets'
    else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    if params[:id].to_i == session[:user_id]
      tweet = Tweet.find_by(id: params[:id])
      tweet.destroy
      redirect to '/tweets'
    else
      redirect to '/tweets'
    end
  end


end
