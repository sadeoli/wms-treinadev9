class Warehouse < ApplicationRecord
    validates :name, :description, :code, :adress, :city, :cep, :area, :state, presence: true

end
