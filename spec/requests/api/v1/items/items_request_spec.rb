require 'rails_helper'

RSpec.describe "Items API Requests" do
  describe 'GET /items' do
    it 'sends a list of all items with default params when unspecified' do
      create(:merchant_with_items, items_count: 30)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq "item"

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a Hash

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_an(Float)
      end

    end
      # it 'can take optional page params'
      # /todos.paginate(page: params[:page], per_page: 20)
      # need to build out response to suit the specs for a return format (and only return specified data)
      # test what happens if no data
      # test for query params, need tests for each independently or both
  end
end
