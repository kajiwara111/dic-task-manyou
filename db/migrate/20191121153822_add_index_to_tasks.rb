class AddIndexToTasks < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, %i[task_name state]
  end
end
