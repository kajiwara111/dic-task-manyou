class AddColumnStateToTasks2 < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :state, :integer, default: 0, limit: 1
  end
end
