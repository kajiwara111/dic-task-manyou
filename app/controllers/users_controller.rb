class UsersController < ApplicationController
  #ログインしてなければshow, edit画面には遷移させない
  before_action :login_check, only: %i[show edit]

  #ログイン中のユーザー以外のshow, edit表示させない
  before_action :user_check, only: %i[show edit]

  def new
    if logged_in? #ログインしている場合、新規ユーザー登録画面には遷移しないよう
      redirect_to tasks_path
    else
      @user = User.new
    end
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を更新しました'
      redirect_to user_path(@user.id)
    else
      flash.now[:danger] = 'ユーザー情報の更新に失敗しました'
      render :edit
    end
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
