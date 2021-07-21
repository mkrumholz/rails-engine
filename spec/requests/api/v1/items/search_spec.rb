require 'rails_helper'

RSpec.describe 'search items' do
  describe 'GET /api/v1/items/find' do
    context 'when searching by name/description' do
      context 'and matches are found' do
        it 'returns all items matching that search in their name or description' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          # should show up in results
          item_1 = create(:item, name: 'Gourd of the Rings', merchant: merchant_1)
          item_2 = create(:item, name: 'beetle beets', description: 'ringourd star', merchant: merchant_1)
          item_3 = create(:item, name: 'Poor Moorings', merchant: merchant_2)

          # should not show up in results
          item_4 = create(:item, name: 'Loom of Doom', description: 'Your worst loom nightmare', merchant: merchant_2) 

          get "/api/v1/items/find", params: { name: 'ring'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data].length).to eq 3

          first_item = result[:data].first
          expect(first_item[:id]).to eq item_2.id.to_s
          expect(first_item[:type]).to eq "item"
          expect(first_item[:attributes]).to be_a Hash
          expect(first_item[:attributes][:name]).to eq item_2.name

          second_item = result[:data].second
          expect(first_item[:id]).to eq item_1.id.to_s
          expect(first_item[:type]).to eq "item"
          expect(first_item[:attributes]).to be_a Hash
          expect(first_item[:attributes][:name]).to eq item_1.name

          third_item = result[:data].last
          expect(first_item[:id]).to eq item_3.id.to_s
          expect(first_item[:type]).to eq "item"
          expect(first_item[:attributes]).to be_a Hash
          expect(first_item[:attributes][:name]).to eq item_3.name
        end
      end

      context 'and no matches are found' do
        it 'should return a 200 status code and empty array' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          get "/api/v1/items/find", params: { name: 'ring'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data]).to be_empty
        end
      end
    end

    # context 'when searching by price' do
    #   context 'and only min price is present' do
        
    #   end

    #   context 'and only max price is present' do
        
    #   end

    #   context 'and both params are present' do
        
    #   end
    # end

    # context 'when attempt is made to search with both sets of params' do
    #   # should error 
    # end

    # context 'when params are missing or empty' do
      
    # end
  end
end
