class ChangeTasksTaskNameNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :task_name, false
  end
end
