class Supplier < ApplicationRecord
    has_many :product_models
    validates :corporate_name, :brand_name, :registration_number, :email, presence: true
    validates :registration_number, uniqueness: true
    validates :registration_number, cnpj: true
end
