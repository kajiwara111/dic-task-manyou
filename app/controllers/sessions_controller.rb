class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user #session helperで定義したメソッド session[:user_id] = user.id
      redirect_to tasks_path
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end
end
