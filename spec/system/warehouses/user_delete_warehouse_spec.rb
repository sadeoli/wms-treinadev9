require 'rails_helper'

describe 'Usuário remove um galpão' do
    it 'com sucesso' do 
        # Arrange
        Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                        address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')

        # Act
        visit root_path
        click_on 'Aeroporto SP'
        click_on 'Remover'

        # Assert
        expect(current_path).to eq root_path
        expect(page).to have_content 'Galpão removido com sucesso'
        expect(page).not_to have_content 'Aeroporto SP'
        expect(page).not_to have_content 'GRU'
    end

    it 'e não apaga outros galpões' do
        # Arrange
        Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                         address: 'Avenida do Aeroporto, 1020', cep: '15000-000', state: 'SP',
                        description: 'Galpão destinado a cargas internacionais')
        Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, 
                        description: 'Galpão do Rio', address: 'Av. do Porto, 1000', 
                            cep: '20000-000', state: 'RJ')


        # Act
        visit root_path
        click_on 'Aeroporto SP'
        click_on 'Remover'

        # Assert
        expect(current_path).to eq root_path
        expect(page).to have_content 'Galpão removido com sucesso'
        expect(page).not_to have_content 'Aeroporto SP'
        expect(page).not_to have_content 'GRU'
        expect(page).to have_content'Rio'
        expect(page).to have_content 'SDU'
    end
end
