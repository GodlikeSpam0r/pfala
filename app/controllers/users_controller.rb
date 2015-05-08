require 'bson'
class UsersController < ApplicationController
  before_filter :authenticate_user!

  def users
    #redirect_to :back, status: :found, :flash => {:status => :fail, :notice => "Email already registered"}
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def add_show
    render 'devise/registrations/new'
  end

end
