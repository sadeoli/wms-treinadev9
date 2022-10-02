require 'rails_helper'

describe 'Usuário edita um pedido' do
    it 'e deve estar autenticado' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)

        # Act
        visit edit_order_path(order.id)


        # Assert 
        expect(current_path).to eq new_user_session_path
    end


    it 'com sucesso' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        other_supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                            registration_number: '30887491891504', full_address: 'Torre da Indústria, 1', 
                            city: 'Teresina', state: 'PI', email: 'vendas@stark.com', phone: '08645756352' )
        order = Order.create!(user: user, warehouse: warehouse, supplier: other_supplier, 
                            estimated_delivery_date: 1.day.from_now)
        

        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Editar'
        fill_in 'Data Prevista de Entrega', with: 2.days.from_now
        select 'ACME LTDA (CNPJ:43.572.202/1007-60)', from: 'Fornecedor'
        click_on 'Gravar'

        # Assert
        expect(page).to have_content 'Pedido atualizado com sucesso.'
        expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA (CNPJ:43.572.202/1007-60)'
        formatted_date = I18n.localize(2.day.from_now.to_date)
        expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
    end

    it 'caso seja o responsável' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        other_user = User.create!(name: 'Jose', email: 'jose@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)

        # Act
        login_as(other_user)
        visit edit_order_path(first_order.id)
        
        # Assert
        expect(current_path).not_to eq order_path(first_order.id)
        expect(current_path).to eq root_path
    end
end