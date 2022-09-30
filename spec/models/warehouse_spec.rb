require 'rails_helper'

RSpec.describe Warehouse, type: :model do
    describe '#valid?' do
        context 'presence' do
            it  'false when name is empty' do
            # Arrange
            warehouse = Warehouse.new(name: '', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                            description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')
            
            # Act
            result = warehouse.valid?

            # Assert
            expect(result).to eq false
            end

            it  'false when code is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: '', city: 'Rio de Janeiro', area: 60000, 
                                description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')
                
                # Act
                result = warehouse.valid?
        
                # Assert
                expect(result).to eq false
            end

            it  'false when city is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: '', area: 60000, 
                                description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')
                
                # Act
                result = warehouse.valid?
        
                # Assert
                expect(result).to eq false
            end

            it  'false when area is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: '', 
                                description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')
                
                # Act
                result = warehouse.valid?
        
                # Assert
                expect(result).to eq false
            end

            it  'false when description is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                description: '', address: 'Av. do Porto, 1000', cep: '20000-000', state: 'RJ')
                
                # Act
                result = warehouse.valid?
        
                # Assert
                expect(result).to eq false
            end

            it  'false when address is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                description: 'Galpão do Rio', address: '', cep: '20000-000', state: 'RJ')
                
                # Act
                result = warehouse.valid?
        
                # Assert
                expect(result).to eq false
            end

            it  'false when cep is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '', state: 'RJ')
                
                # Act
                result = warehouse.valid?
    
                # Assert
                expect(result).to eq false
            end

            it  'false when state is empty' do
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                description: 'Galpão do Rio', address: 'Av. do Porto, 1000', cep: '20000-000', state: '')
                
                # Act
                result = warehouse.valid?
    
                # Assert
                expect(result).to eq false
            end
        end

        context 'uniqueness' do
            it 'false when code is lready in use' do 
                # Arrange
                Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                                    description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                                                    cep: '20000-000', state: 'RJ')

                warehouse = Warehouse.new(name: 'Niteroi', code: 'SDU', city: 'Niteroi', area: 65000, 
                                                description: 'Galpão de Niteroi', address: 'Av. do Porto, 50',
                                                cep: '30000-000', state: 'RJ')

                # Act
                result = warehouse.valid?

                # Assert
                expect(result).to eq false
            end

            it 'false when cep is lready in use' do 
                # Arrange
                Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                                    description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                                                    cep: '20000-000', state: 'RJ')

                warehouse = Warehouse.new(name: 'Niteroi', code: 'NIT', city: 'Niteroi', area: 65000, 
                                                description: 'Galpão de Niteroi', address: 'Av. do Porto, 50',
                                                cep: '20000-000', state: 'RJ')

                # Act
                result = warehouse.valid?

                # Assert
                expect(result).to eq false
            end
        end

        context 'format' do
            it 'false when cep is not 00000-000' do 
                # Arrange
                warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60000, 
                                                    description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                                                    cep: '20000000', state: 'RJ')

                # Act
                result = warehouse.valid?

                # Assert
                expect(result).to eq false
            end
        end
    end
    
    describe '#full_description' do
        it 'exibe o nome e o código' do
            # Arrange
            w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')

            # Act
            result = w.full_description()

            # Assert
            expect(result).to eq 'CBA - Galpão Cuiabá'

        end

    end

end
