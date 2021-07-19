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

  describe 'GET items/:id' do
    context 'item exists' do
      it 'returns the specific item details' do
        merchant = create(:merchant)
        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)

        get "/api/v1/items/#{item_1.id}"

        expect(response).to have_http_status(200)

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to be_a Hash

        data = item[:data]
        expect(data[:id]).to eq item_1.id.to_s
        expect(data[:type]).to eq "item"
        expect(data[:attributes]).to be_a Hash

        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes][:name]).to be_an(String)

        expect(data[:attributes]).to have_key(:description)
        expect(data[:attributes][:description]).to be_an(String)

        expect(data[:attributes]).to have_key(:unit_price)
        expect(data[:attributes][:unit_price]).to be_an(Float)
        
        expect(data[:attributes]).to have_key(:merchant_id)
        expect(data[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    context 'item does not exist' do
      it 'returns a status code 404' do 
        get "/api/v1/items/#{14583958}"
        
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end

    context 'request is not valid' do
      it 'returns a status code 404' do
        get "/api/v1/items/string"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /items' do
    context 'when all attributes are present and valid' do
      it 'creates an item and returns a 201 status code' do
        merchant = create(:merchant)
        params = {
          name: "New Item",
          description: "This is a new item.",
          unit_price: 103.58,
          merchant_id: merchant.id
        }

        post '/api/v1/items', params: params

        expect(response).to have_http_status(201)
        expect(merchant.items.last.name).to eq params[:name]
        expect(merchant.items.last.description).to eq params[:description]
        expect(merchant.items.last.unit_price).to eq params[:unit_price]
        expect(merchant.items.last.merchant_id).to eq params[:merchant_id]

        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data]).to be_a Hash

        data = item[:data]
        expect(data[:id]).to eq merchant.items.last.id.to_s
        expect(data[:type]).to eq "item"
        expect(data[:attributes]).to be_a Hash

        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes][:name]).to be_an(String)

        expect(data[:attributes]).to have_key(:description)
        expect(data[:attributes][:description]).to be_an(String)

        expect(data[:attributes]).to have_key(:unit_price)
        expect(data[:attributes][:unit_price]).to be_an(Float)
        
        expect(data[:attributes]).to have_key(:merchant_id)
        expect(data[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    context 'when attributes are present but not valid' do
      it 'returns a failure message and 422 status code' do
        merchant = create(:merchant)
        params = {
          name: "New Item",
          description: "This is a new item.",
          unit_price: 'string',
          merchant_id: merchant.id
        }

        post '/api/v1/items', params: params

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Validation failed: Unit price is not a number/)
      end

      it 'cannot create an item without a valid merchant id' do
        params = {
          name: "New Item",
          description: "This is a new item.",
          unit_price: 103.58,
          merchant_id: 17
        }

        post '/api/v1/items', params: params

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Validation failed: Merchant must exist/)
      end
    end

    context 'when required attributes are not present' do
      it 'returns a failure message and status code 422' do
        merchant = create(:merchant)
        params = {
          name: "New Item",
          unit_price: 103.58,
          merchant_id: merchant.id
        }

        post '/api/v1/items', params: params

        expect(response).to have_http_status(422)
        expect(response.body).to match(/Validation failed: Description can't be blank/)
      end
    end

    context 'when extra non-standard attributes are present' do
      it 'creates the item but ignores non-standard attributes' do
        merchant = create(:merchant)
        params = {
          name: "New Item",
          description: "This is a new item.",
          unit_price: 103.58,
          extra_param: "select * from merchants;",
          merchant_id: merchant.id
        }

        post '/api/v1/items', params: params

        expect(response).to have_http_status(201)

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to be_a Hash

        data = item[:data]
        expect(data[:id]).to eq merchant.items.last.id.to_s
        expect(data[:type]).to eq "item"
        expect(data[:attributes]).to be_a Hash
        expect(data).not_to have_key(:extra_param)
      end
    end
  end

  describe 'PATCH /items/:id' do
    context 'when the item exists' do
      context 'when all attributes are present and valid' do
        it 'updates the item and returns a 202 status code' do
          merchant = create(:merchant)
          item = create(:item, merchant: merchant)
          params = {
            name: "New Item",
            description: "This is a new item.",
            unit_price: 103.58,
            merchant_id: merchant.id
          }

          patch "/api/v1/items/#{item.id}", params: params

          expect(response).to have_http_status(202)

          expect(item.name).to eq params[:name]
          expect(item.description).to eq params[:description]
          expect(item.unit_price).to eq params[:unit_price]
          expect(item.merchant_id).to eq params[:merchant_id]

          item = JSON.parse(response.body, symbolize_names: true)
        
          expect(item[:data]).to be_a Hash

          data = item[:data]
          expect(data[:id]).to eq item.id.to_s
          expect(data[:type]).to eq "item"
          expect(data[:attributes]).to be_a Hash

          expect(data[:attributes]).to have_key(:name)
          expect(data[:attributes][:name]).to be_an(String)

          expect(data[:attributes]).to have_key(:description)
          expect(data[:attributes][:description]).to be_an(String)

          expect(data[:attributes]).to have_key(:unit_price)
          expect(data[:attributes][:unit_price]).to be_an(Float)
          
          expect(data[:attributes]).to have_key(:merchant_id)
          expect(data[:attributes][:merchant_id]).to be_an(Integer)
        end
      end

      # context 'when only one attribute is present and valid' do
      #   it 'updates the item and returns a 202 status code' do
      #     merchant = create(:merchant)
      #     item = create(:item, merchant: merchant)
      #     params = {
      #       name: "New Item",
      #       description: "This is a new item.",
      #       unit_price: 103.58,
      #       extra_param: "select * from merchants;",
      #       merchant_id: merchant.id
      #     }
      # patch "/api/v1/items/#{item.id}", params: params
      # #   end
      # end

      # context 'when an invalid attribute is present' do
      #   it 'returns a failure message and 404 status code' do
            # merchant = create(:merchant)
            # item = create(:item, merchant: merchant)
            # params = {
            #   name: "New Item",
            #   description: "This is a new item.",
            #   unit_price: 103.58,
            #   extra_param: "select * from merchants;",
            #   merchant_id: merchant.id
            # }
      #   end
      # end

      # context 'when non-standard attributes are present' do
      #   it 'updates the item, returns a 202 status, and ignores the extra attributes' do
      #       merchant = create(:merchant)
      #       item = create(:item, merchant: merchant)
      #       params = {
      #         name: "New Item",
      #         description: "This is a new item.",
      #         unit_price: 103.58,
      #         extra_param: "select * from merchants;",
      #         merchant_id: merchant.id
      #       }
      # #   end
      # end
    end

    context 'when the no item exists for the id' do
      it 'returns a failure message and 404 status code' do
        merchant = create(:merchant)
        params = {
          name: "New Item",
          description: "This is a new item.",
          unit_price: 103.58,
          merchant_id: merchant.id
        }

        patch "/api/v1/items/string_id", params: params

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
end
