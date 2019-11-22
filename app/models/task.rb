class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :task_content, length: { maximum: 300 }
end
