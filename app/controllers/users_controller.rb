class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url
    else
     render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @followers = @user.followers.where.not(id:@user.followings.ids)
    @friends = current_user.followings & current_user.followers
    unless current_user.id == params[:id].to_i
      log_out if logged_in?
      redirect_to root_url
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(update_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    followers = Friend.where(follower_id: params[:id])
    followers.each do |follower|
      follower.destroy
    end
    followings = Friend.where(following_id: params[:id])
    followings.each do |following|
      following.destroy
    end
    groups = UserGroup.where(user_id: params[:id])
    groups.each do |group|
      group.destroy
    end
    redirect_to root_url
  end

  def delete
    @user = User.find(params[:id])
    render :delete
  end

  private

  def user_params
    params.require(:user).permit(:name,:call,:password,:password_confirmation,:image)
  end

  def update_params
    params.require(:user).permit(:name, :image, :call)
  end
end
