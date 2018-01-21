class Task < ActiveRecord::Base

  belongs_to :board, required: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incompleted, -> { where(completed_at: nil) }
end
