require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
    it 'com sucesso' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
                        registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
                         city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')

        # Act
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
end