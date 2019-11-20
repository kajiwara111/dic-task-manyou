class Task < ApplicationRecord
  validates :task_name, presence: true, length: { maximum: 30 }
  validates :task_content, length: { maximum: 300 }
  validates :deadline, presence: true
  enum state: [:not_yet_started, :in_progress, :finished]

  def self.ransackable_attributes(auth_object = nil)
    %w[task_name state]
  end

  def self.ransackable_associations(auth_object=nil)
    []
  end
end
