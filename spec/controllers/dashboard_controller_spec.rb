require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe '#GET index' do
    let(:data) { json_response["data"] }

    it 'returns data for one board' do
      board1 = create(:board)
      create(:task, board_id: board1.id)
      create(:task, board_id: board1.id)
      create(:task, :completed, board_id: board1.id)

      get :index

      expect(response.status).to eq(200)
      expect(data).to eq('total_boards' => 1, 'total_tasks' => 3, 'total_incomplete_tasks' => 2)
    end

    it 'returns data for two boards' do
      board1 = create(:board)
      create(:task, board_id: board1.id)
      create(:task, board_id: board1.id)
      create(:task, :completed, board_id: board1.id)

      board2 = create(:board)
      create(:task, :completed, board_id: board2.id)
      create(:task, :completed, board_id: board2.id)

      get :index

      expect(response.status).to eq(200)
      expect(data).to eq('total_boards' => 2, 'total_tasks' => 5, 'total_incomplete_tasks' => 2)
    end

    it 'returns data for ten boards' do
      10.times { create(:board)}

      get :index

      expect(response.status).to eq(200)
      expect(data).to eq('total_boards' => 10, 'total_tasks' => 0, 'total_incomplete_tasks' => 0)
    end

    it 'returns empty data' do
      get :index

      expect(response.status).to eq(200)
      expect(data).to eq('total_boards' => 0, 'total_tasks' => 0, 'total_incomplete_tasks' => 0)
    end
  end

end
