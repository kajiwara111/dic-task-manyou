class TasksController < ApplicationController
  before_action :set_params, only: %i[show edit destroy update]

  def index
    @tasks = Task.all.order(id: 'DESC')
  end
  
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
    params.require(:task).permit(:task_name, :task_content, :deadline)
  end

  def set_params
    @task = Task.find(params[:id])
  end
end
