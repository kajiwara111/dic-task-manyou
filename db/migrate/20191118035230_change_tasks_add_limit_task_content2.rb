class ChangeTasksAddLimitTaskContent2 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :task_content, :text, limit: 300
  end
  def down
    change_column :tasks, :task_content, :text, limit: 300    
  end
end
