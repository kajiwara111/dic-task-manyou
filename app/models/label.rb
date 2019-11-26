class Label < ApplicationRecord
  has_many :labellings, dependent: :destroy
  has_many :label_tasks, through: :labellings, source: :task
end
