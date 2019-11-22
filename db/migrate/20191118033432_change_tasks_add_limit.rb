class ChangeTasksAddLimit < ActiveRecord::Migration[5.2]
  #change_columnではバージョン戻す処理をバージョンあげる処理から自動生成できない。
  #よってup, downにわけないと、マイグレーション取り消すときに例外が発生する
  def up
    change_column :tasks, :task_name, :string, limit: 30
    change_column :tasks, :task_content, :text, limit: 255
  end
  def down
    change_column :tasks, :task_name, :string, limit: 30
    change_column :tasks, :task_content, :text, limit: 255
  end
end
