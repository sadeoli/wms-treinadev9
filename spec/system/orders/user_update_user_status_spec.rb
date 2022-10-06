require 'rails_helper'

describe 'Usuário informa novo status do pedido' do
    it 'e pedido foi entregue' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        product_model = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                            sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now, status: :pending)
        order_item = OrderItem.create!(order: order, product_model: product_model, quantity: 5)

        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Marcar como ENTREGUE'

        # Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content 'Status do Pedido: Entregue'
        expect(page).not_to have_button 'Marcar como CANCELADO'
        expect(page).not_to have_button 'Marcar como ENTREGUE'
        expect(StockProduct.count).to eq 5
        estoque = StockProduct.where(warehouse:warehouse, product_model:product_model).count
        expect(estoque).to eq 5

    end

    it 'e pedido foi cancelado' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        product_model = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                            sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now, status: :pending)
        order_item = OrderItem.create!(order: order, product_model: product_model, quantity: 5)

        # Act
        login_as(user)
        visit root_path
        click_on 'Meus Pedidos'
        click_on order.code
        click_on 'Marcar como CANCELADO'

        # Assert
        expect(current_path).to eq order_path(order.id)
        expect(page).to have_content 'Status do Pedido: Cancelado'
        expect(StockProduct.count).to eq 0
    end
end