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

  def follower
    user = User.find(params[:follower_id])
    follower = Friend.find_by(follower_id: user.id, following_id: current_user.id)
    follower.destroy
    redirect_back(fallback_location: root_path)
  end

  def following
    user = User.find(params[:following_id])
    following = Friend.find_by(follower_id: current_user.id, following_id: user.id)
    following.destroy
    redirect_back(fallback_location: root_path)
  end

  def delete
    @user = User.find(current_user.id)
    @friend = User.find(params[:id])
    render 'delete'
  end

  def break
    friend = User.find(params[:friend_id])
    friend_1 = Friend.find_by(follower_id: friend.id, following_id: current_user.id)
    friend_2 = Friend.find_by(following_id: friend.id, follower_id: current_user.id)
    friend_1.destroy
    friend_2.destroy
    redirect_to controller: :users, action: :show, id: current_user.id
  end
end
