require 'rails_helper'

describe 'Warehouse API' do
    context 'GET /api/v1/warehouses/1' do
        it 'success' do
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
            expect(json_response.keys).not_to include 'created_at'
            expect(json_response.keys).not_to include 'updated_at'
        end

        it 'fail if warehouse not found' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')

    
            # Act
            login_as user
            get "/api/v1/warehouses/9999"
    
    
            # Assert
            expect(response.status).to eq 404
            
        end
    end

    context 'GET /api/v1/warehouses' do
        it 'success' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                        description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')

            # Act
            login_as user
            get "/api/v1/warehouses"
            
            # Assert
            expect(response.status).to eq 200
            expect(response.content_type).to include 'application/json'

            json_response = JSON.parse(response.body)
            expect(json_response.length).to eq 2
            expect(json_response.first['name']).to eq 'Aeroporto SP'
            expect(json_response.second['name']).to eq 'Rio'
        end

        it 'return empty if there is no warehouse' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')


            # Act
            login_as user
            get "/api/v1/warehouses"
    
    
            # Assert
            expect(response.status).to eq 200
            expect(response.content_type).to include 'application/json'

            json_response = JSON.parse(response.body)
            expect(json_response).to eq []
        end
    end
end