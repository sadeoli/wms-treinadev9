require 'rails_helper'

describe 'Usuário vê o estoque' do
    it 'na tela do galpão' do
        # Arrange
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
            phone: '01148178530')
        product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                sku: 'TV32-SAMSU-CPTO90256' , supplier: supplier)
        product_soundbar = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, 
                    depth: 20, sku: 'SOU71-SAMSU-NOI27778', supplier: supplier)
        product_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9, 
                        depth: 20, sku: 'NOTEI5-SAMSU-16GBRAM', supplier: supplier)
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                    description: 'Galpão destinado a cargas internacionais')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)

        3.times {StockProduct.create!(order:order,warehouse:warehouse,product_model:product_tv)}
        2.times {StockProduct.create!(order:order,warehouse:warehouse,product_model:product_notebook)}

        # Act
        login_as(user)
        visit root_path
        click_on 'Aeroporto SP'

        # Assert
        expect(page).to have_content 'Itens em Estoque'
        expect(page).to have_content '3 x TV32-SAMSU-CPTO90256'
        expect(page).to have_content '2 x NOTEI5-SAMSU-16GBRAM'
        expect(page).not_to have_content 'SOU71-SAMSU-NOI27778'

    end
end