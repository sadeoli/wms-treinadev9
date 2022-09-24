require 'rails_helper'

RSpec.describe Supplier, type: :model do
    describe '#valid?' do
        context 'presence' do
            it  'false when corporate name is empty' do
            # Arrange
            supplier = Supplier.new(corporate_name: '', brand_name: 'ACME', registration_number: '4344721608726', 
                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                 phone: '01148178530')
            
            # Act
            result = supplier.valid?

            # Assert
            expect(result).to eq false
            end

            it  'false when brand name is empty' do
                # Arrange
                supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: '', registration_number: '4344721608726', 
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                     phone: '01148178530')
                
                # Act
                result = supplier.valid?
    
                # Assert
                expect(result).to eq false
            end

            it  'false when registration number is empty' do
                # Arrange
                supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '', 
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
                
                # Act
                result = supplier.valid?
    
                # Assert
                expect(result).to eq false
            end

            it  'false when corporate e-mail is empty' do
                # Arrange
                supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4344721608726', 
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: '',
                        phone: '01148178530')
                
                # Act
                result = supplier.valid?
    
                # Assert
                expect(result).to eq false
            end

        end

        context 'uniqueness' do
            it 'false when registration number is lready in use' do 
                # Arrange
                Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                                phone: '01148178530')
                supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                            registration_number: '43572202100760', full_address: 'Torre da Indústria, 1', 
                            city: 'Teresina', state: 'PI', email: 'vendas@stark.com', phone: '08645756352' )


                # Act
                result = supplier.valid?

                # Assert
                expect(result).to eq false
            end
        end

        
        context 'format' do
            it 'false when registration number is not valid' do 
                # Arrange
                supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                        registration_number: '4357220210076', full_address: 'Torre da Indústria, 1', 
                        city: 'Teresina', state: 'PI', email: 'vendas@stark.com', phone: '08645756352' )

                # Act
                result = supplier.valid?

                # Assert
                expect(result).to eq false
            end
        end

    end
end
