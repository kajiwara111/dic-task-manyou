class Admin::UsersController < ApplicationController
  #ログインしてなければshow, edit画面には遷移させない
  #before_action :login_check, only: %i[show edit]

  #ログイン中のユーザー以外のshow, edit表示させない
  #before_action :user_check, only: %i[show edit]
  
  #管理者のみユーザー管理機能使用可、それ以外はrootに遷移させる
  before_action :check_admin

  def index
    @users = User.all.order(admin: 'DESC').page(params[:page]) #管理者を上位表示
  end
  
  def new
    #if logged_in? #ログインしている場合、新規ユーザー登録画面には遷移しないよう設定
    #  redirect_to tasks_path
    #else
    @user = User.new
    #end
  end

  #管理者として自分以外の他ユーザーを新規登録
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "新規ユーザーとして#{@user.name}さんを登録しました"
      redirect_to admin_users_path
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
      #binding.pry
      flash[:notice] = "#{@user.name}さんのアカウント情報を更新しました"
      redirect_to admin_users_path
    else
      flash.now[:danger] = "#{}さんのアカウント情報更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    isLoginUser = (@user.id == current_user.id)
    if @user.destroy #before_destroyの結果で条件分岐。管理ユーザー一人しかいない場合、削除不可
      if isLoginUser #ログインユーザー自身のアカウントを削除した場合はログアウト
        redirect_to new_session_path, notice: "あなたのアカウントを削除してログアウトしました"
      else
        redirect_to admin_users_path, notice: "ユーザー#{@user.name}さんを削除しました"
      end
    else 
      flash[:alert] = '管理ユーザーが一人しかいないためこのユーザーを削除できません'
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :admin
    )
  end
end