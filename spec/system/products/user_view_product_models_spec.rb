require 'rails_helper'

describe 'Usuario vê modelos de produtos' do
    it 'a partir do menu' do
        # Arrange

        # Act
        visit root_path
        within('nav') do
            click_on 'Modelos de Produtos'
        end

        # Assert
        expect(current_path).to eq product_models_path
    end

    
    it 'com sucesso' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung Eletronicos LTDA',
             registration_number: '43572202100760', full_address: 'Av das Nacoes Unidas, 100', 
             city: 'São Paulo', state: 'SP', email: 'contato@samsung.com', phone: '01148178530')
        ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                            sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, 
                            depth: 20, sku: 'SOU71-SAMSU-NOI27778', supplier: supplier)
        # Act
        visit root_path
        within('nav') do
            click_on 'Modelos de Produtos'
        end

        # Assert
        expect(page).to have_content 'TV 32'
        expect(page).to have_content 'TV32-SAMSU-CPTO90256'
        expect(page).to have_content 'Samsung'
        expect(page).to have_content 'SoundBar 7.1 Surround'
        expect(page).to have_content 'SOU71-SAMSU-NOI27778'
    end

    it 'e não existem modelos de produtos cadastrados' do
        # Arrange

        # Act
        visit root_path
        within('nav') do
            click_on 'Modelos de Produtos'
        end

        # Assert
        expect(page).to have_content('Não existem modelos de produtos cadastrados.')
    end
end