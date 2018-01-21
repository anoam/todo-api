require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let (:data) { json_response["data"] }
  let (:errors) { json_response["errors"] }

  describe '#GET index' do

    it 'returns empty collection when no tasks' do
      board = create(:board)
      get :index, board_id: board.id
      expect(data).to eql([])
    end

    it 'returns empty data when no tasks in requested' do
      board1 = create(:board)
      board2 = create(:board)
      create(:task, board_id: board1.id)

      get :index, board_id: board2.id
      expect(data).to eql([])
    end

    it 'returns 404 when board nox exists' do
      get :index, board_id: 0
      expect(response.status).to be(404)
      expect(errors).to include('board not found')
    end

    describe "filtering" do
      let(:board) { create(:board) }
      before do
        create(:task, board_id: board.id, title: 'title1', description: 'descr1')
        create(:task, board_id: board.id, title: 'title2', description: 'descr2')
        create(:task, :completed, board_id: board.id, title: 'title3', description: 'descr3')
      end

      it 'returns tasks when exists' do
        get :index, board_id: board.id

        expect(data.size).to eql(3)

        expect(data.first['title']).to eql('title1')
        expect(data.first['description']).to eql('descr1')
        expect(data.first['completed_at']).to be_nil

        expect(data.second['title']).to eql('title2')
        expect(data.second['description']).to eql('descr2')
        expect(data.second['completed_at']).to be_nil

        expect(data.third['title']).to eql('title3')
        expect(data.third['description']).to eql('descr3')
        expect(data.third['completed_at']).to be_a(String)
      end

      it 'returns only completed tasks' do
        get :index, board_id: board.id, type: :completed

        expect(data.size).to eql(1)
        expect(data.first['title']).to eql('title3')
        expect(data.first['description']).to eql('descr3')
      end

      it 'returns only incompleted tasks' do
        get :index, board_id: board.id, type: :incompleted

        expect(data.size).to eql(2)
        expect(data.first['title']).to eql('title1')
        expect(data.first['description']).to eql('descr1')

        expect(data.second['title']).to eql('title2')
        expect(data.second['description']).to eql('descr2')
      end
    end
  end

  describe '#GET show' do
    let(:board) { create(:board) }

    it 'returns error if object not exists' do
      get :show, id: 42

      expect(response.status).to eql(404)
      expect(errors).to include('task not found')
    end


    it 'returns object' do
      task = create(:task, title: 'title', description: 'descr', board_id: board.id)

      get :show, id: task.id

      expect(response.status).to eql(200)
      expect(data['title']).to eql('title')
      expect(data['description']).to eql('descr')
    end
  end

  describe '#POST create' do
    context 'when board not exists' do
      it 'returns 404' do
        post :create, board_id: 0, task: { title: 'my title', description: 'my descr' }

        expect(response.status).to eql(404)
        expect(errors).to include('board not found')
      end
    end

    context 'when board exists' do
      let(:board) { create(:board) }

      it 'fails on invalid params' do
        post :create, board_id: board.id, task: { title: '' }

        expect(response.status).to eql(422)
        expect(json_response['errors']).to include("Title can't be blank")
        expect(json_response['errors']).to include("Description can't be blank")
      end

      it 'creates response with new board' do
        post :create, board_id: board.id, task: { title: 'my title', description: 'my descr' }

        expect(response.status).to eql(201)

        expect(data['title']).to eql('my title')
        expect(data['description']).to eql('my descr')
      end

      it 'creates new board' do
        expect { post(:create, board_id: board.id, task: { title: 'my title', description: 'my descr' }) }
            .to change { Task.where(title: 'my title', description: 'my descr', board_id: board.id).count }.from(0).to(1)
      end
    end
  end

  describe '#POST complete' do
    let(:board) { create(:board) }

    it 'returns error if object not exists' do
      post :complete, id: 42

      expect(response.status).to eql(404)
      expect(errors).to include('task not found')
    end

    it 'returns error if  task already completed' do
      task = create(:task, :completed, board_id: board.id)
      post :complete, id: task.id

      expect(response.status).to eql(422)
      expect(errors).to include("can't complete")
    end

    it "returns task" do
      task = create(:task, board_id: board.id)
      post :complete, id: task.id

      expect(response.status).to eql(200)
      expect(data["completed_at"]).not_to be_nil
    end

    it 'completes task' do
      task = create(:task, board_id: board.id)
      expect { post(:complete, id: task.id, board_id: board.id) }
          .to change { Task.find(task.id).completed_at }.from(nil)
    end
  end

  describe '#PATCH update' do
    let(:board) { create(:board) }

    context 'when task not exists' do
      it 'returns error' do
        patch :update, id: 0, task: { description: 'new descr' }
        expect(response.status).to eql(404)
        expect(errors).to include("task not found")
      end
    end

    context 'when task exists' do
      let(:task) { create(:task, title: 'my title', description: 'my description', board_id: board.id) }

      it 'fails on invalid params' do
        patch :update, id: task.id, task: { title: '' }
        expect(response.status).to eql(422)
        expect(errors).to include("Title can't be blank")
      end

      it 'updates response with updated object' do
        patch :update,id: task.id, task: { title: 'new title' }
        expect(response.status).to eql(200)

        expect(data['title']).to eql('new title')
        expect(data['description']).to eql('my description')
      end

      it 'updates attributes' do
        expect { patch(:update, id: task.id, task: { description: 'new descr' }) }
            .to change { Task.find(task.id).description }.from('my description').to('new descr')
      end
    end
  end

  describe '#DELETE destroy' do
    let(:board) { create(:board) }
    let(:task) { create(:task, board_id: board.id) }

    it 'return error if object not found' do
      delete :destroy, id: 0

      expect(response.status).to eql(404)
      expect(errors).to include('task not found')
    end

    it 'deletes board' do
      expect { delete(:destroy, id: task.id) }
          .to change { Task.find_by(id: task.id) }.to nil
    end

    it 'response with 204' do
      delete :destroy, id: task.id
      expect(response.status).to be(204)
    end
  end
end
