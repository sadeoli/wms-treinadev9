require 'rails_helper'

describe 'Warehouse API' do
    it 'GET /api/v1/warehouses/1' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')

        # Act
        login_as user
        get "/api/v1/warehouses/#{warehouse.id}"


        # Assert
        expect(response.status).to eq 200
        expect(response.content_type).to include 'application/json'

        json_response = JSON.parse(response.body)

        expect(json_response["name"]).to eq 'Aeroporto SP'
        expect(json_response["code"]).to eq 'GRU'

    end
end