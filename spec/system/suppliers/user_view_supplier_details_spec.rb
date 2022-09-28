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

    it 'e vê informações de modelo de produto' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                        full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                        phone: '01148178530')
        pm = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                            sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)

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
        expect(page).to have_content 'TV 32'
        expect(page).to have_content 'TV32-SAMSU-CPTO90256'
        expect(page).to have_content '10cm x 45cm x 70cm'
        expect(page).to have_content '8000g'
    end
end