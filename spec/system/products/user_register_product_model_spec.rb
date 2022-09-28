require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
    it 'com sucesso' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                        registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                         city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
        other_supplier = Supplier.create!(corporate_name: 'LG Industries Brasil LTDA', brand_name: 'LG', 
                        registration_number: '30887491891504', full_address: 'Torre da Indústria, 1', 
                        city: 'Teresina', state: 'PI', email: 'vendas@lg.com', phone: '08645756352')

        # Act
        login_as(user)
        visit root_path
        click_on 'Modelos de Produtos'
        click_on 'Cadastrar novo modelo de produto'
        fill_in 'Nome', with: 'TV 32'
        fill_in 'Peso', with: 8000
        fill_in 'Altura', with: 45
        fill_in 'Largura', with: 70
        fill_in 'Profundidade', with: 10
        fill_in 'SKU', with: 'TV32-SAMSU-CPTO90256'
        select 'Samsung', from: 'Fornecedor'
        click_on 'Enviar'

        # Assert
        expect(page).to have_content 'Modelo de produto cadastrado com sucesso.'
        expect(page).to have_content 'TV 32'
        expect(page).to have_content 'TV32-SAMSU-CPTO90256'
        expect(page).to have_content 'Dimensão: 10cm x 45cm x 70cm'
        expect(page).to have_content 'Peso: 8000g'
        expect(page).to have_content 'Fornecedor: Samsung'
    end

    it 'deve preencher todos os campos' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                        registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                         city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')

        # Act
        login_as(user)
        visit root_path
        click_on 'Modelos de Produtos'
        click_on 'Cadastrar novo modelo de produto'
        fill_in 'Nome', with: ''
        fill_in 'Peso', with: ''
        fill_in 'Altura', with: ''
        fill_in 'Largura', with: ''
        fill_in 'Profundidade', with: ''
        fill_in 'SKU', with: ''
        select 'Samsung', from: 'Fornecedor'
        click_on 'Enviar'

        # Assert
        expect(page).to have_content 'Não foi possível cadastrar o modelo de produto.'
    
    end
end