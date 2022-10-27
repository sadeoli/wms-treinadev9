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

        it 'and raise internal error' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

            # Act
            login_as user
            get "/api/v1/warehouses"

            # Assert
            expect(response).to have_http_status 500

        end
    end

    context 'POST /api/v1/warehouses' do
        it 'success' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse_params = { warehouse: {name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                            address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                                            description: 'Galpão destinado a cargas internacionais'}}


            # Act
            login_as user
            post "/api/v1/warehouses", params: warehouse_params

            # Assert
            expect(response).to have_http_status :created
            expect(response.content_type).to include 'application/json'

            json_response = JSON.parse(response.body)

            expect(json_response["name"]).to eq 'Aeroporto SP'
            expect(json_response["code"]).to eq 'GRU'
            expect(json_response["city"]).to eq 'Guarulhos'
            expect(json_response["area"]).to eq 100000
            expect(json_response["address"]).to eq 'Avenida do Aeroporto, 1020'
            expect(json_response["cep"]).to eq '15000-000'
            expect(json_response["state"]).to eq 'SP'
            expect(json_response["description"]).to eq 'Galpão destinado a cargas internacionais'           
        end

        it 'fail if parameters are not complete' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse_params = { warehouse: {name: 'Aeroporto Curitiba', code: 'CWB'}}


            # Act
            login_as user
            post "/api/v1/warehouses", params: warehouse_params

            # Assert
            expect(response).to have_http_status 412
            expect(response.content_type).to include 'application/json'
            expect(response.body).not_to include 'Nome não pode ficar em branco'
            expect(response.body).not_to include 'Código não pode ficar em branco'
            expect(response.body).to include 'Cidade não pode ficar em branco'
            expect(response.body).to include 'Endereço não pode ficar em branco'
        end

        it 'fail if theres an internal error' do
            # Arrange
            allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse_params = { warehouse: {name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                            address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                                            description: 'Galpão destinado a cargas internacionais'}}


            # Act
            login_as user
            post "/api/v1/warehouses", params: warehouse_params

            # Assert
            expect(response).to have_http_status 500
        end
    end
end