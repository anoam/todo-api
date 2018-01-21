class Task < ActiveRecord::Base

  belongs_to :board, required: true

end
