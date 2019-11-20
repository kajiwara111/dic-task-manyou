class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :task_content, length: { maximum: 300 }
  validates :deadline, presence: true
  enum status:{ not_yet_started: 0, in_progress: 1, finished:2 }
end
