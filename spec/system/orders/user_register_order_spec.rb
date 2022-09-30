require 'rails_helper'

describe 'Usuário cadastra um pedido' do
    it 'e deve estar autenticado' do
        # Arrange

        # Act
        visit root_path
        click_on 'Registrar Pedido'
        
        # Assert
        expect(current_path).to eq new_user_session_path
    end


    it 'com sucesso' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, 
            description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                cep: '20000-000', state: 'RJ')
        Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                    registration_number: '30887491891504', full_address: 'Torre da Indústria, 1', 
                    city: 'Teresina', state: 'PI', email: 'vendas@stark.com', phone: '08645756352' )
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                            phone: '01148178530')


        # Act
        login_as(user)
        visit root_path
        click_on 'Registrar Pedido'
        select warehouse.name, from: 'Galpão Destino'
        select supplier.corporate_name, from: 'Fornecedor'
        fill_in 'Data Prevista', with: '20/12/2022'
        click_on 'Gravar'



        # Assert
        expect(page).to have_content 'Pedido registrado com sucesso'
        expect(page).to have_content 'Galpão Destino: Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA'
        expect(page).to have_content 'Data Prevista de Entrega: 20/12/2022'
        expect(page).to have_content 'Usuário Responsável: Maria | maria@email.com'
        expect(page).not_to have_content 'Rio'
        expect(page).not_to have_content 'Spark'
    end

end