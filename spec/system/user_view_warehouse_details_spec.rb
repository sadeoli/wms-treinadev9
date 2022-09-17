require 'rails_helper'

describe 'Usuario vê detalhes de um galpão' do
    it 'e vê informações adicionais' do
        # Arrange
        w = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                            adress: 'Avenida do Aeroporto, 1020', cep: '15000-000', 
                                description: 'Galpão destinado a cargas internacionais')

        # Act
        visit root_path
        click_on('Aeroporto SP')

        # Assert
        expect(page).to have_content('Galpão GRU')
        expect(page).to have_content('Nome: Aeroporto SP')
        expect(page).to have_content('Cidade: Guarulhos')
        expect(page).to have_content('Área: 100000 m2')
        expect(page).to have_content('Endereço: Avenida do Aeroporto, 1020')
        expect(page).to have_content('CEP: 15000-000')
        expect(page).to have_content('Galpão destinado a cargas internacionais')

    end
end