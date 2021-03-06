module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) 
  end

  def logged_in?
    current_user.present?
  end

  def login_check
    unless logged_in?
        flash[:alert] = "ログインしてください"
        redirect_to new_session_path
    end
  end

  #他ユーザーのタスク詳細、編集画面にアクセスしようとした場合、一覧画面に遷移させるメソッド
  def task_user_check
    user = Task.find(params[:id]).user 
    redirect_to tasks_path unless current_user.id == user.id
  end

  #他ユーザーの詳細、編集画面にアクセスしようとした場合、一覧画面に遷移させるメソッド
  def user_check
    user = User.find(params[:id]) 
    redirect_to tasks_path unless current_user.id == user.id
  end

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  #管理者かどうか判定
  def check_admin
    redirect_to root_url unless current_user.admin?
  end
end
