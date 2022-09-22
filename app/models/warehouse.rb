class Warehouse < ApplicationRecord
    validates :name, :description, :code, :adress, :city, :cep, :area, :state, presence: true
    validates :code, :cep, uniqueness: true
    validates :cep, format: { with: /[0-9]{5}-[0-9]{3}/ }
end
