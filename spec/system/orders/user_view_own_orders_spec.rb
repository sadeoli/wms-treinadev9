require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
    it 'e deve estar autenticado' do
        # Arrange

        # Act
        visit root_path

        # Assert
        expect(page).not_to have_link 'Meus Pedidos'
    end

    it 'e não vê outros pedidos' do
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
                            estimated_delivery_date: 1.day.from_now, status: 'pending')
        second_order = Order.create!(user: other_user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 2.day.from_now, status: 'delivered')
        third_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                    estimated_delivery_date: 1.day.from_now, status: 'canceled')

        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        
        # Assert
        expect(page).to have_content first_order.code
        expect(page).to have_content 'Pendente'
        expect(page).not_to have_content second_order.code
        expect(page).not_to have_content 'Entregue'
        expect(page).to have_content third_order.code
        expect(page).to have_content 'Cancelado'

    end

    it 'e visita um pedido' do
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
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        
        # Assert
        expect(page).to have_content order.code
        expect(page).to have_content 'Detalhes do Pedido'
        expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA (CNPJ:43.572.202/1007-60)'
        formatted_date = I18n.localize(1.day.from_now.to_date)
        expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
    end 

    it 'e não visita pedidos de outros usuários' do
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
        visit order_path(first_order.id)
        
        # Assert
        expect(current_path).not_to eq order_path(first_order.id)
        expect(current_path).to eq root_path
        expect(page).to have_content 'Você não possui acesso a esse pedido.'
    end

    it 'e vê itens do pedido' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')
        product_a = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        product_b = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, 
                depth: 20, sku: 'SOU71-SAMSU-NOI27778', supplier: supplier)
        product_c = ProductModel.create!(name: 'SoundBar 8 Surround', weight: 4000, width: 120, height: 17, 
                    depth: 20, sku: 'SOU80-SAMSU-NOI27778', supplier: supplier)
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)
        OrderItem.create!(product_model: product_a, order: order, quantity:19)
        OrderItem.create!(product_model: product_b, order: order, quantity:12)

        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        
        # Assert
        expect(page).to have_content 'Itens do Pedido'
        expect(page).to have_content '19 x TV 32'
        expect(page).to have_content '12 x SoundBar 7.1 Surround'
    end 
end