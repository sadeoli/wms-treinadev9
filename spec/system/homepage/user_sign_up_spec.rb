require 'rails_helper'

describe 'Usuario se cadastra' do
    it 'com sucesso' do
        # Arrange

        # Act
        visit root_path
        click_on 'Entrar'
        click_on 'Sign up'
        within('form') do
            fill_in 'Nome', with: 'Maria'
            fill_in 'E-mail', with: 'maria@email.com'
            fill_in 'Senha', with: 'password'
            fill_in 'Confirme sua senha', with: 'password'
            click_on 'Sign up'
        end

        # Assert
        expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
        within('nav') do
            expect(page).not_to have_link 'Entrar'
            expect(page).to have_button 'Sair'
            expect(page).to have_content 'maria@email.com'
        end
        user = User.last
        expect(user.name).to eq 'Maria'
    end
end
