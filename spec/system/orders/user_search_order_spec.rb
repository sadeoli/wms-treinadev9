require 'rails_helper'

describe 'Usuário busca por um pedido' do
    it 'e deve estar autenticado' do
        # Arrange

        # Act
        visit root_path


        # Assert
        within ('header nav') do
            expect(page).not_to have_field('Buscar Pedido')
            expect(page).not_to have_button('Buscar')
        end

    end


    it 'a partir do menu' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')


        # Act
        login_as(user)
        visit root_path


        # Assert
        within ('header nav') do
            expect(page).to have_field('Buscar Pedido')
            expect(page).to have_button('Buscar')
        end
    end

    it 'e encontra um pedido' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                            phone: '01148178530')
        order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)


        # Act
        login_as(user)
        visit root_path
        fill_in 'Buscar Pedido', with: order.code
        click_on 'Buscar'

        # Assert
        expect(page).to have_content "Resultados da Busca por: #{order.code}"
        expect(page).to have_content '1 pedido encontrado'
        expect(page).to have_content "Código: #{order.code}"
        expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA (CNPJ:43.572.202/1007-60)'

    end


    it 'e encontra múltiplos pedidos' do
        # Arrange
        user = User.create!(name: 'Maria', email: 'maria@email.com', password: 'password')
        first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
        second_warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, 
                            description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                                cep: '20000-000', state: 'RJ')
        supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43572202100760', 
                            full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com',
                            phone: '01148178530')
        allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('GRUDA5SAY2')
        first_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
        allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('GRUDA4JAY2')
        second_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, 
                                    estimated_delivery_date: 2.day.from_now)
        allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('SDUUDA5SAY2')
        third_order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier, 
                                        estimated_delivery_date: 1.day.from_now)


        # Act
        login_as(user)
        visit root_path
        fill_in 'Buscar Pedido', with: 'GRU'
        click_on 'Buscar'

        # Assert
        expect(page).to have_content "Resultados da Busca por: GRU"
        expect(page).to have_content '2 pedidos encontrados'
        expect(page).to have_content "Código: GRUDA5SAY2"
        expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA (CNPJ:43.572.202/1007-60)'
        expect(page).to have_content "Código: GRUDA4JAY2"
        expect(page).not_to have_content "Código: SDUUDA5SAY2"
        expect(page).not_to have_content 'Galpão Destino: SDU - Rio'

    end
end