class Task < ActiveRecord::Base

  belongs_to :board, required: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incompleted, -> { where(completed_at: nil) }


  validates :title, presence: true
  validates :description, presence: true

  def completed?
    completed_at.present?
  end

  def can_complete?
    !completed?
  end

  def complete!
    raise("Cant complete!") unless can_complete?

    self.completed_at = Time.now
  end

end
