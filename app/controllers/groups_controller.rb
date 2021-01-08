class GroupsController < ApplicationController
  def index
    @groups = UserGroup.where(user_id: current_user.id).order(updated_at: :desc)
  end

  def new
    @group = Group.new
    @users = User.where.not(id: current_user.id)
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      UserGroup.create(group_id: @group.id, user_id: current_user.id)
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @members = UserGroup.where(group_id: @group.id).where.not(user_id: current_user.id)
    @user = User.find(current_user.id)
    @wakeup = UserGroup.find_by(user_id: current_user.id, group_id: params[:id])
  end

  def edit
    @group = Group.find_by(id: params[:id])
  end

  def update
    @group = Group.find_by(id: params[:id])
    if @group.update(group_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def search
    search = params[:search]
    @friends = User.where(['name LIKE ?', "%#{search}%"]) & current_user.followings & current_user.followers
    render :add
  end

  def wakeup
    @wakeup = UserGroup.find_by(user_id: current_user.id, group_id: params[:id])
      @wakeup.wake_up = true
    if @wakeup.save
      redirect_to action: :show
    end
  end

  def sleep
    @sleep = UserGroup.find_by(user_id: current_user.id, group_id: params[:id])
    @sleep.wake_up = false
    if @sleep.save
      redirect_to action: :show
    end
  end

  def reset
    group = Group.find(params[:id])
    group.time = nil
    members = UserGroup.where(group_id: params[:id])
    members.each do |member|
      member.wake_up = false
      member.save
    end
    if group.save
        redirect_to action: :show
    end
  end

  def add
    @friends = current_user.followings & current_user.followers
    render :add
  end

  def make
    unless UserGroup.find_by(user_id: params[:friend_id], group_id: params[:id])
      UserGroup.create(user_id: params[:friend_id], group_id: params[:id])
    else
      @nest = UserGroup.find_by(user_id: params[:friend_id], group_id: params[:id])
      @nest.destroy
    end
    redirect_back(fallback_location: root_path)
  end

  def time
    group = Group.find(params[:id])
    date = params[:date]
    datetime = DateTime.new(date["date(1i)"].to_i,date["date(2i)"].to_i,date["date(3i)"].to_i,date["date(4i)"].to_i,date["date(5i)"].to_i)
    group.time = datetime
    if group.save
      redirect_to action: :show
    end
  end

  def how
    render :how
  end

  private

  def group_params
    params.require(:group).permit(:name, :image)
  end
end
