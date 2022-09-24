require 'rails_helper'

describe 'Usuario vê detalhes de um fornecedor' do
    it 'e vê informações adicionais' do
        # Arrange
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')

        # Act
        visit root_path
        within('nav') do
            click_on 'Fornecedores'
        end
        click_on 'ACME'

        # Assert
        expect(page).to have_content 'ACME'
        expect(page).to have_content 'ACME LTDA'
        expect(page).to have_content 'CNPJ: 43572202100760'
        expect(page).to have_content 'Endereço: Av das Palmas, 100 - Bauru - SP'
        expect(page).to have_content 'E-mail: contato@acme.com'
        expect(page).to have_content 'Telefone: 01148178530'
    end

    it 'e volta para a tela inicial' do
        # Arrange
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                    phone: '01148178530')

        # Act
        visit root_path
        within('nav') do
        click_on 'Fornecedores'
        end
        click_on 'ACME'
        click_on 'Voltar'

        # Assert
        expect(current_path).to eq(root_path)
    end
end