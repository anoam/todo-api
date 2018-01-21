require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  let (:data) { json_response }
  let (:errors) { json_response["errors"] }

  describe '#GET index' do
    it 'returns no boards' do
      get :index
      expect(response.status).to be(200)
      expect(data).to eql([])
    end

    it 'returns one board' do
      create(:board, title: 'title', description: 'descr')
      get :index

      expect(response.status).to be(200)
      expect(data.size).to eql(1)
      expect(data.first['title']).to eql('title')
      expect(data.first['description']).to eql('descr')
    end

    it 'returns two boards' do
      create(:board, title: 'title1', description: 'descr1')
      create(:board, title: 'title2', description: 'descr2')
      get :index

      expect(response.status).to be(200)
      expect(data.size).to eql(2)
      expect(data.first['title']).to eql('title1')
      expect(data.first['description']).to eql('descr1')
      expect(data.second['title']).to eql('title2')
      expect(data.second['description']).to eql('descr2')
    end
  end

  describe '#GET show' do
    it 'returns error if object not exists' do
      get :show, id: 42

      expect(response.status).to eql(404)
      expect(errors).to include('board not found')
    end


    it 'returns object' do
      board = create(:board, title: 'title', description: 'descr')

      get :show, id: board.id

      expect(response.status).to eql(200)
      expect(data['title']).to eql('title')
      expect(data['description']).to eql('descr')
    end
  end

  describe '#POST create' do
    it 'fails on invalid params' do
      post :create, board: { title: '' }
      expect(response.status).to eql(422)
      expect(json_response['errors']).to include("Title can't be blank")
      expect(json_response['errors']).to include("Description can't be blank")
    end

    it 'creates response with new board' do
      post :create, board: { title: 'my title', description: 'my descr' }

      expect(response.status).to eql(201)

      expect(data['title']).to eql('my title')
      expect(data['description']).to eql('my descr')
    end

    it 'creates new board' do
      expect { post(:create, board: { title: 'my title', description: 'my descr' }) }
          .to change { Board.where(title: 'my title', description: 'my descr').count }.from(0).to(1)

    end
  end

  describe '#PATCH update' do
    let(:board) { create(:board, title: 'my title', description: 'my descr') }

    it 'return error if object not found' do
      patch :update, id: 0, board: { title: '' }

      expect(response.status).to eql(404)
      expect(errors).to include('board not found')
    end

    it 'fails on invalid params' do
      patch :update, id: board.id, board: { title: '' }
      expect(response.status).to eql(422)
      expect(errors).to include("Title can't be blank")
    end

    it 'updates response with updated object' do
      patch :update, id: board.id, board: { title: 'new title' }
      expect(response.status).to eql(200)

      expect(data['title']).to eql('new title')
      expect(data['description']).to eql('my descr')
    end

    it 'updates attributes' do

      expect { patch(:update, id: board.id, board: { description: 'new descr' }) }
        .to change { Board.find(board.id).description }
    end
  end

  describe '#DELETE destroy' do
    let(:board) { create(:board) }

    it 'return error if object not found' do
      delete :destroy, id: 0

      expect(response.status).to eql(404)
      expect(errors).to include('board not found')
    end

    it 'deletes board' do
      expect { delete(:destroy, id: board.id) }
          .to change { Board.find_by(id: board.id) }.to nil
    end

    it 'response with 204' do

      delete :destroy, id: board.id
      expect(response.status).to be(204)
    end
  end

end
