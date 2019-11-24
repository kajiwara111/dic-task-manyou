class TasksController < ApplicationController
  before_action :set_params, only: %i[show edit destroy update]
  before_action :login_check
  before_action :task_user_check, only: %i[show edit] #ログイン中ユーザー以外の詳細、編集画面にアクセス不可とする処理

  def index
    current_user_tasks = current_user.tasks
    #@q = Task.ransack(params[:q]) #この記述がないとviewで@qが未定義エラーでる
    @q = current_user_tasks.ransack(params[:q])
    if params[:q]
      @tasks = @q.result(distinct: true).page(params[:page])
    elsif params[:sort_type] == "1"
      @tasks = current_user_tasks.order(deadline: 'ASC').page(params[:page])
    elsif params[:sort_type] == "2"
      @tasks = current_user_tasks.order(priority: 'DESC').page(params[:page])
    else
      @tasks = current_user_tasks.order(created_at: 'DESC').page(params[:page])
    end
  end
  
  def new
    @task = Task.new
  end

  def create
    #@task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = '新規タスクを登録しました'
      redirect_to tasks_path
    else
      flash.now[:danger] = "タスクの登録に失敗しました"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクを削除しました'
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクを更新しました'
    else
      render :edit, alert: 'タスクの更新に失敗しました'
    end
  end

  private

  def task_params
    params
      .require(:task).permit(
        :task_name,
        :task_content,
        :deadline,
        :state,
        :priority
    )
  end

  def set_params
    @task = Task.find(params[:id])
  end
end
