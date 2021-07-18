require 'rails_helper'

RSpec.describe "Items API Requests" do
  describe 'GET /items' do
    context 'when pagination params are unspecified' do
      it 'sends a list of first 20 items with default params' do
        create(:merchant_with_items, items_count: 30)

        get '/api/v1/items'

        expect(response).to have_http_status(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(20)

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_an(String)

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

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end
      end
    end

    context 'when pagination params are present' do
      context 'and only per_page is specified' do
        it 'sends the appropriate list length and defaults to page 1' do
          create(:merchant_with_items, items_count: 30)

          all_items = Item.all

          get '/api/v1/items', params: {per_page: 10}

          expect(response).to have_http_status(200)

          items = JSON.parse(response.body, symbolize_names: true)

          expect(items[:data].count).to eq(10)
          expect(items[:data].first[:id]).to eq all_items.first.id.to_s
          expect(items[:data].last[:id]).to eq all_items[9].id.to_s

          items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)

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
            
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
          end
        end
      end

      context 'and only page is specified' do
        it 'sends the correct items for page and defaults to 20 per page' do
          create(:merchant_with_items, items_count: 30)

          all_items = Item.all

          get '/api/v1/items', params: {page: 2}

          expect(response).to have_http_status(200)

          items = JSON.parse(response.body, symbolize_names: true)

          expect(items[:data].count).to eq(10)
          expect(items[:data].first[:id]).to eq all_items[20].id.to_s
          expect(items[:data].last[:id]).to eq all_items.last.id.to_s

          items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)

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
            
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
          end
        end

        it 'defaults to page 1 if page param is specified as < 1' do
          create(:merchant_with_items, items_count: 30)

          all_items = Item.all

          get '/api/v1/items', params: {page: 0}

          expect(response).to have_http_status(200)

          items = JSON.parse(response.body, symbolize_names: true)

          expect(items[:data].count).to eq(20)
          expect(items[:data].first[:id]).to eq all_items.first.id.to_s
          expect(items[:data].last[:id]).to eq all_items[19].id.to_s

          items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)

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
            
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
          end
        end
      end
      
      context 'and both params are specified' do
        it 'sends the appropriate items and list length for the params' do
          create(:merchant_with_items, items_count: 30)

          all_items = Item.all

          get '/api/v1/items', params: {page: 2, per_page: 10}

          expect(response).to have_http_status(200)

          items = JSON.parse(response.body, symbolize_names: true)

          expect(items[:data].count).to eq(10)
          expect(items[:data].first[:id]).to eq all_items[10].id.to_s
          expect(items[:data].last[:id]).to eq all_items[19].id.to_s

          items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)

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
            
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
          end
        end
      end
    end

    context 'when no data is available' do
      it 'returns an empty array' do
        get '/api/v1/items'

        expect(response).to have_http_status(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data]).to eq([])
      end
    end
  end
end
