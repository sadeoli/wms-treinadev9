require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do
    it 'com sucesso' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')
        product_a = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        product_b = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, 
                depth: 20, sku: 'SOU71-SAMSU-NOI27778', supplier: supplier)
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)


        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Adicionar Item'
        select 'TV 32', from: 'Produto'
        fill_in 'Quantidade', with: '8'
        click_on 'Gravar'


        # Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content 'Item adicionado com sucesso'
        expect(page).to have_content '8 x TV 32'
        expect(page).not_to have_content '12 x SoundBar 7.1 Surround'
    end

    it 'e não vê produtos de outro fornecedor' do
        # Arrange
        supplier_a = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')
        supplier_b = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                registration_number: '30887491891504', full_address: 'Torre da Indústria, 1', 
                city: 'Teresina', state: 'PI', email: 'vendas@stark.com', phone: '08645756352' )
        product_a = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier_a)
        product_b = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, 
                depth: 20, sku: 'SOU71-SAMSU-NOI27778', supplier: supplier_b)
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, 
                            estimated_delivery_date: 1.day.from_now)


        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Adicionar Item'
    


        # Assert
        expect(page).to have_content 'TV 32'
        expect(page).not_to have_content 'SoundBar 7.1 Surround'
    end
end