require 'rails_helper'

RSpec.describe 'search merchants' do
  describe 'GET /api/v1/merchants/find' do
    context 'when there is at least one merchant matching the search criterion' do
      context 'when there is only one match' do
        it 'returns the single match' do
          merchant_2 = create(:merchant, name: 'Iliad Ventures')
          merchant_3 = create(:merchant, name: 'The Tilt')
          merchant_4 = create(:merchant, name: 'Mortimer\'s Mysteries')
          merchant_4 = create(:merchant, name: 'nilla\'s wafers')

          get "/api/v1/merchants/find", params: { name: 'iLl'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_a Hash

          data = result[:data]
          expect(data[:id]).to eq merchant_4.id.to_s
          expect(data[:type]).to eq "merchant"
          expect(data[:attributes]).to be_a Hash

          expect(data[:attributes]).to have_key(:name)
          expect(data[:attributes][:name]).to eq merchant_4.name
        end
      end

      context 'when there are multiple possible matches' do
        it 'returns the single match that comes first in case-insensitive order' do
          merchant_1 = create(:merchant, name: 'Illy')
          merchant_2 = create(:merchant, name: 'Iliad Ventures')
          merchant_3 = create(:merchant, name: 'The Tilt')
          merchant_4 = create(:merchant, name: 'Mortimer\'s Mysteries')
          merchant_4 = create(:merchant, name: 'nilla\'s wafers')

          get "/api/v1/merchants/find", params: { name: 'iLl'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_a Hash

          data = result[:data]
          expect(data[:id]).to eq merchant_1.id.to_s
          expect(data[:type]).to eq "merchant"
          expect(data[:attributes]).to be_a Hash

          expect(data[:attributes]).to have_key(:name)
          expect(data[:attributes][:name]).to eq merchant_1.name
        end
      end
    end

    context 'when no merchant matches the search criterion' do
      it 'returns an empty json response and status code 200' do
        merchant_2 = create(:merchant, name: 'Iliad Ventures')
        merchant_3 = create(:merchant, name: 'The Tilt')
        merchant_4 = create(:merchant, name: 'Mortimer\'s Mysteries')

        get "/api/v1/merchants/find", params: { name: 'iLl'}
          
        expect(response).to have_http_status(200)
        expect(response.body).to eq ''
      end
    end
  end
end
