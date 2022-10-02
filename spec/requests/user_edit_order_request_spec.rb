require 'rails_helper'

describe 'Usuário edita um pedido' do
    it 'e não é o dono' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        other_user = User.create!(name: 'Jose', email: 'jose@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

        # Act
        login_as(other_user)
        patch(order_path(order.id), params: { order: { estimated_delivery_date: 2.days.from_now}})
        
        # Assert
        expect(response).to redirect_to root_path
    end
end