require 'rails_helper'

RSpec.describe Board, type: :model do
  describe '#tasks' do
    subject { create(:board) }
    let(:other_board) { create(:board) }
    let(:task1) { create(:task, board_id: subject.id) }
    let(:task2) { create(:task, board_id: subject.id) }
    let(:excluded_task) { create(:task, board_id: other_board.id) }

    it { expect(subject.tasks).to include(task1) }
    it { expect(subject.tasks).to include(task2) }
    it { expect(subject.tasks).not_to include(excluded_task) }
  end
end
