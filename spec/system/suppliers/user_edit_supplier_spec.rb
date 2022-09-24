require 'rails_helper'

describe 'Usuário edita um fornecedor' do 
    it 'a partir da página de detalhes' do
        # Arrange
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                    phone: '01148178530')

        # Act
        visit root_path
        click_on 'Fornecedores'
        click_on 'ACME'
        click_on 'Editar'

        # Assert
        expect(page).to have_content 'Editar Fornecedor'
        expect(page).to have_field 'Nome Fantasia', with: 'ACME'
        expect(page).to have_field 'Razão Social', with: 'ACME LTDA'
        expect(page).to have_field 'CNPJ', with: '43572202100760'
        expect(page).to have_field 'Endereço', with: 'Av das Palmas, 100'
        expect(page).to have_field 'Cidade', with: 'Bauru'
        expect(page).to have_field 'Estado', with: 'SP'
        expect(page).to have_field 'E-mail', with: 'contato@acme.com'
        expect(page).to have_field 'Telefone', with: '01148178530'
    end

    it 'com sucesso' do
        # Arrange
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')

        # Act
        visit root_path
        click_on 'Fornecedores'
        click_on 'ACME'
        click_on 'Editar'
        fill_in 'Nome Fantasia', with: 'ACME e FTL LTA'
        fill_in 'Razão Social', with: 'ACME e FTL'
        fill_in 'CNPJ', with: '54877992689078'
        fill_in 'Endereço', with: 'Av das Palmas, 66'
        fill_in 'Cidade', with: 'Campinas'
        fill_in 'Estado', with: 'SP'
        fill_in 'E-mail', with: 'contato@acme.com'
        fill_in 'Telefone', with: '01148178530'
        click_on 'Enviar'

        # Assert
        expect(page).to have_content 'Fornecedor atualizado com sucesso.'
        expect(page).to have_content 'ACME e FTL'
        expect(page).to have_content 'Campinas - SP'  
    end

    it 'e mantém os campos obrigatórios' do
        # Arrange
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')

        # Act
        visit root_path
        click_on 'Fornecedores'
        click_on 'ACME'
        click_on 'Editar'
        fill_in 'Nome Fantasia', with: ''
        fill_in 'Razão Social', with: ''
        fill_in 'CNPJ', with: ''
        fill_in 'E-mail', with: ''
        click_on 'Enviar'

        # Assert
        expect(page).to have_content 'Não foi possível atualizar o fornecedor.'
    end
end