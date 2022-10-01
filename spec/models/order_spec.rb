require 'rails_helper'

RSpec.describe Order, type: :model do
    describe '#valid?' do
        it 'deve ter um código' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                            phone: '01148178530')
            order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)    

            # Act
            result = order.valid?

            # Assert
            expect(result).to be true
        end

        it 'data estimada deve ser obrigatória' do
            # Arrange
            order = Order.new(estimated_delivery_date: '')    
                                
            # Act
            order.valid? 
            result = order.errors.include?(:estimated_delivery_date)

            # Assert
            expect(result).to be true
        end

        it 'data estimada não deve ser passada' do
            # Arrange
            order = Order.new(estimated_delivery_date: 1.day.ago)    
                                
            # Act
            order.valid? 

            # Assert
            expect(order.errors.include?(:estimated_delivery_date)).to be true
            expect(order.errors[:estimated_delivery_date]).to include(" deve ser futura.")
        end

        it 'data estimada não deve ser igual a hoje' do
            # Arrange
            order = Order.new(estimated_delivery_date: Date.today)    
                                
            # Act
            order.valid? 

            # Assert
            expect(order.errors.include?(:estimated_delivery_date)).to be true
            expect(order.errors[:estimated_delivery_date]).to include(" deve ser futura.")
        end

        it 'data estimada deve ser igual ou posterior a amanhã' do
            # Arrange
            order = Order.new(estimated_delivery_date: 1.day.from_now)    
                                
            # Act
            order.valid? 

            # Assert
            expect(order.errors.include?(:estimated_delivery_date)).to be false
        end

    end


    describe 'gera um código aleatório' do
        it 'ao criar novo pedido' do
            # Arrange
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                            phone: '01148178530')
            order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)    

            # Act
            order.save!
            result = order.code

            # Assert
            expect(result).not_to be_empty
            expect(result.length).to eq 10
        end

        it 'e o código é único' do
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
            other_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 2.day.from_now)    

            # Act
            other_order.save!

            # Assert
            expect(other_order.code).not_to eq order.code
        end
    end
end
