class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :task_content, length: { maximum: 300 }
  validates :deadline, presence: true

  #not_yet_started, in_progress, finishedがそれぞれ0,1,2に対応
  #要素を削除したら数値と文字列の対応関係も変わりうるので注意
  enum state: %i[not_yet_started in_progress finished]
  enum priority: %i[low middle high]

  #association
  belongs_to :user

  #検索に使用できるカラムを制限
  def self.ransackable_attributes(auth_object = nil)
    %w[task_name state]
  end

  def self.ransackable_associations(auth_object=nil)
    []
  end
end
