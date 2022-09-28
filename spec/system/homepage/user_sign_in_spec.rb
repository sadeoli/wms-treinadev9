require 'rails_helper'

describe 'Usuario se autentica' do
    it 'com sucesso' do
        # Arrange
        User.create!(email: 'sade@email.com', password: 'password')

        # Act
        visit root_path
        within('form') do
            fill_in 'E-mail', with: 'sade@email.com'
            fill_in 'Senha', with: 'password'
            click_on 'Entrar'
        end

        # Assert
        expect(page).to have_content 'Login efetuado com sucesso.'
        within('nav') do
            expect(page).not_to have_link 'Entrar'
            expect(page).to have_button 'Sair'
            expect(page).to have_content 'sade@email.com'
        end
    end

    it 'e faz logout' do
        # Arrange
        User.create!(email: 'sade@email.com', password: 'password')

        # Act
        visit root_path
        within('form') do
            fill_in 'E-mail', with: 'sade@email.com'
            fill_in 'Senha', with: 'password'
            click_on 'Entrar'
        end
        click_on 'Sair'

        # Assert
        expect(page).to have_content 'Para continuar, faça login ou registre-se.'
        within('nav') do
            expect(page).to have_link 'Entrar'
            expect(page).not_to have_button 'Sair'
            expect(page).not_to have_content 'sade@email.com'
        end
    
    end
end
