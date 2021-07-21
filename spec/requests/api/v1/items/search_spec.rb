require 'rails_helper'

RSpec.describe 'search items' do
  describe 'GET /api/v1/items/find_all' do
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

          get "/api/v1/items/find_all", params: { name: 'ring'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data].length).to eq 3

          first_item = result[:data].first
          expect(first_item[:id]).to eq item_2.id.to_s
          expect(first_item[:type]).to eq "item"
          expect(first_item[:attributes][:name]).to eq item_2.name

          second_item = result[:data].second
          expect(second_item[:id]).to eq item_1.id.to_s
          expect(second_item[:type]).to eq "item"
          expect(second_item[:attributes][:name]).to eq item_1.name

          third_item = result[:data].last
          expect(third_item[:id]).to eq item_3.id.to_s
          expect(third_item[:type]).to eq "item"
          expect(third_item[:attributes][:name]).to eq item_3.name
        end
      end

      context 'and no matches are found' do
        it 'should return a 200 status code and empty array' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          get "/api/v1/items/find_all", params: { name: 'ring'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data]).to be_empty
        end
      end
    end

    context 'when searching by price' do
      context 'and only min price is present' do
        it 'returns all items above that price' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          # should show up in results
          item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
          item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
          item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

          # should not show up in results
          item_4 = create(:item, unit_price: 50.00, merchant: merchant_2) 

          get "/api/v1/items/find_all", params: { min_price: 70 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data].length).to eq 3
        end
      end

      context 'and only max price is present' do
        it 'returns all items below that price' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          # should show up in results
          item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
          item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
          item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

          # should not show up in results
          item_4 = create(:item, unit_price: 160.00, merchant: merchant_2) 

          get "/api/v1/items/find_all", params: { max_price: 150 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data].length).to eq 3
        end
      end

      context 'and both params are present' do
        it 'returns all items between the listed prices' do
          merchant_1 = create(:merchant, name: 'Rings and Things')
          merchant_2 = create(:merchant, name: 'Book Nook')

          # should show up in results
          item_1 = create(:item, unit_price: 140.00, merchant: merchant_1)
          item_2 = create(:item, unit_price: 100.00, merchant: merchant_1)
          item_3 = create(:item, unit_price: 75.00, merchant: merchant_2)

          # should not show up in results
          item_4 = create(:item, unit_price: 40.00, merchant: merchant_2) 

          get "/api/v1/items/find_all", params: { min_price: 70, max_price: 150 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an Array
          expect(result[:data].length).to eq 3
        end
      end
    end

    context 'when attempt is made to search with both sets of params' do
      it 'should return an error and 400 status code' do
        merchant_1 = create(:merchant, name: 'Rings and Things')
        item_1 = create(:item, name: 'Gourd of the Rings', merchant: merchant_1)

        get "/api/v1/items/find_all", params: { name: 'ring', max_price: 100.00 }

        expect(response).to have_http_status(400)
      end
    end

    context 'when params are missing or empty' do
      it 'should return an error and 400 status code' do
        merchant_1 = create(:merchant, name: 'Rings and Things')
        item_1 = create(:item, name: 'Gourd of the Rings', merchant: merchant_1)

        get "/api/v1/items/find_all", params: { name: nil }

        expect(response).to have_http_status(400)
      end
    end
  end
end
