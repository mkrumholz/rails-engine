require 'rails_helper'

RSpec.describe "Items API Requests" do
  describe 'GET /items' do
    it 'sends a list of all items' do
      create(:merchant_with_items)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(5)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)

        expect(item).to have_key(:name)
        expect(item[:name]).to be_an(String)

        expect(item).to have_key(:description)
        expect(item[:description]).to be_an(String)

        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).to be_an(Float)

        expect(item).to have_key(:merchant_id)
        expect(item[:merchant_id]).to be_an(Integer)
      end

    end
      # it 'can take optional page params'
      # /todos.paginate(page: params[:page], per_page: 20)
      # need to build out response to suit the specs for a return format (and only return specified data)
      # test what happens if no data
      # test for query params, need tests for each independently or both
  end
end
