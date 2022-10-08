require 'rails_helper'

RSpec.describe StockProduct, type: :model do
    describe 'gera um número de série' do
        it 'ao criar um StockProduct' do
            # Arrange
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                phone: '01148178530')
            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                    sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)

            # Act
            stock_product = StockProduct.create!(order:order,warehouse:warehouse,product_model:product)

            # Assert
            expect(stock_product.serial_number.length).to eq 20
        end

        it 'e não é modificado' do
            # Arrange
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                phone: '01148178530')
            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                    sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            order_a = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
            order_b = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                    estimated_delivery_date: 2.day.from_now)
            stock_product = StockProduct.create!(order:order_a,warehouse:warehouse,product_model:product)
            original_serial_number = stock_product.serial_number

            # Act
            stock_product.update!(order:order_b)

            # Assert
            expect(stock_product.serial_number).to eq original_serial_number
        end
    end


    describe '#available?' do
        it 'true se não tiver destino' do
            # Arrange
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                phone: '01148178530')
            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                    sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)

            # Act
            stock_product = StockProduct.create!(order:order,warehouse:warehouse,product_model:product)

            # Assert
            expect(stock_product.available?).to eq true
        end

        it 'false se tiver destino' do
            # Arrange
            supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                phone: '01148178530')
            product = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                    sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
            user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
            warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
            order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
            stock_product = StockProduct.create!(order:order,warehouse:warehouse,product_model:product)

            # Act
            stock_product.create_stock_product_destination!(recipient: 'Joao', address: 'Rua da Liberdade')
            

            # Assert
            expect(stock_product.available?).to eq false
        end
    end
end
