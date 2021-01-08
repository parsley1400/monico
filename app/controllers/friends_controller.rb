class FriendsController < ApplicationController
  def show
    @user = User.find(params[:id])
    @followers = @user.followers.where.not(id:@user.followings.ids)
    @friend = Friend.new
    unless current_user.id == params[:id].to_i
      log_out if logged_in?
      redirect_to root_url
    end
  end

  def new
    @users = User.where.not(id: current_user.id)
    @friend = Friend.new
    @friends = Friend.all
  end

  def create
    user = User.find(params[:friend][:following_id])
    Friend.create(follower_id: current_user.id, following_id: user.id)
    @users = User.where.not(id: current_user.id)
    @friend = Friend.new
    @friends = Friend.all
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user = Friend.find(params[:id]).following
    current_user.unfollow!(@user)
  end

  def search
    search = params[:search]
    @users = User.where(['name LIKE ?', "%#{search}%"]).where.not(id: current_user.id)
    @friend = Friend.new
    @friends = Friend.all
    render 'new'
  end
end
