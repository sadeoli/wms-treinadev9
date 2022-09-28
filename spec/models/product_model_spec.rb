require 'rails_helper'

RSpec.describe ProductModel, type: :model do
    describe '#valid?' do
        context 'presence' do
            it  'false when name is empty' do
            # Arrange
            supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
            pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10, 
                               sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
            
            # Act
            result = pm.valid?
            
            # Assert
            expect(result).to eq false
            end

            it  'false when weight is empty' do
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: '', width: 70, height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
                
                # Act
                result = pm.valid?
                
                # Assert
                expect(result).to eq false
            end

            it  'false when width is empty' do
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: '', height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
                
                # Act
                result = pm.valid?
                
                # Assert
                expect(result).to eq false
            end

            it  'false when height is empty' do
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: '', depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
                
                # Act
                result = pm.valid?
                
                # Assert
                expect(result).to eq false
            end

            it  'false when depth is empty' do
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: '', 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
                
                # Act
                result = pm.valid?
                
                # Assert
                expect(result).to eq false
            end

            it  'false when sku is empty' do
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                                   sku: '' , supplier: supplier)
                
                # Act
                result = pm.valid?
                
                # Assert
                expect(result).to eq false
            end

        end

        context 'uniqueness' do
            it 'false when sku is lready in use' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
                other_pm = ProductModel.new(name: 'TV 32 LG', weight: 10000, width: 80, height: 55, depth: 12, 
                    sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)


                # Act
                result = other_pm.valid?


                # Assert
                expect(result).to eq false
            end
        end

        context 'lenght' do
            it 'false when sku has not 20 caracters' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO9056' , supplier: supplier)


                # Act
                result = pm.valid?


                # Assert
                expect(result).to eq false
            end
        end

        context 'numericality' do
            it 'false when weight is 0' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 0, width: 70, height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)

                # Act
                result = pm.valid?


                # Assert
                expect(result).to eq false
            end

            it 'false when width is 0' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 0, height: 45, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)

                # Act
                result = pm.valid?


                # Assert
                expect(result).to eq false
            end

            it 'false when height is 0' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 800, width: 70, height: 0, depth: 10, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)

                # Act
                result = pm.valid?


                # Assert
                expect(result).to eq false
            end

            it 'false when depth is 0' do 
                # Arrange
                supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                    registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
                pm = ProductModel.new(name: 'TV 32', weight: 800, width: 70, height: 45, depth: 0, 
                                   sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)

                # Act
                result = pm.valid?


                # Assert
                expect(result).to eq false
            end


        end
    end
end
