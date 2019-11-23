class UsersController < ApplicationController
  before_action :login_check, only: %i[show edit]
  before_action :user_check, only: %i[show edit]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #ユーザー登録と同時にログイン
      flash[:success] = "新規ユーザーを登録し、ログインしました"
      redirect_to tasks_path
    else
      flash.now[:alert] = "ユーザー登録に失敗しました。"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit

  end

  def update

  end

  def destroy

  end



  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

end
