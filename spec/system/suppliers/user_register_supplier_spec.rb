require 'rails_helper'

describe 'Usuário cadastra um galpão' do 
    it 'a partir de tela inicial' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')

        # Act
        login_as(user)
        visit root_path
        click_on 'Fornecedores'
        click_on 'Cadastrar novo fornecedor'

        # Assert
        expect(page).to have_field('Nome Fantasia')
        expect(page).to have_field('Razão Social')
        expect(page).to have_field('CNPJ')
        expect(page).to have_field('Endereço')
        expect(page).to have_field('Cidade')
        expect(page).to have_field('Estado')
        expect(page).to have_field('E-mail')
        expect(page).to have_field('Telefone')
    end

    it 'com sucesso' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')

        # Act
        login_as(user)
        visit root_path
        click_on 'Fornecedores'
        click_on 'Cadastrar novo fornecedor'
        fill_in 'Nome Fantasia', with: 'ACME LTA'
        fill_in 'Razão Social', with: 'ACME'
        fill_in 'CNPJ', with: '43572202100760'
        fill_in 'Endereço', with: 'Av das Palmas, 100'
        fill_in 'Cidade', with: 'Bauru'
        fill_in 'Estado', with: 'SP'
        fill_in 'E-mail', with: 'contato@acme.com'
        fill_in 'Telefone', with: '01148178530'
        click_on 'Enviar'

        # Assert
        expect(current_path).to eq suppliers_path
        expect(page).to have_content 'Fornecedor cadastrado com sucesso.'
        expect(page).to have_content 'ACME'
        expect(page).to have_content 'Bauru - SP'  
    end

    it 'com dados incompletos' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')

        # Act
        login_as(user)
        visit root_path
        click_on 'Fornecedores'
        click_on 'Cadastrar novo fornecedor'
        fill_in 'Nome Fantasia', with: ''
        fill_in 'Razão Social', with: ''
        fill_in 'CNPJ', with: ''
        fill_in 'E-mail', with: ''
        click_on 'Enviar'

        # Assert
        expect(page).to have_content 'Fornecedor não cadastrado.'
        expect(page).to have_content "Nome Fantasia não pode ficar em branco"
        expect(page).to have_content "Razão Social não pode ficar em branco"
        expect(page).to have_content "CNPJ não pode ficar em branco"  
        expect(page).to have_content "E-mail não pode ficar em branco"  
    end
end