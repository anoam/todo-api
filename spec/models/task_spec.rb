require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#board' do
    let(:board) { create(:board) }
    subject { create(:task, board_id: board.id) }

    it { expect(subject.board).to eql(board) }
  end
end
