class Supplier < ApplicationRecord
    has_many :product_models
    validates :corporate_name, :brand_name, :registration_number, :email, presence: true
    validates :registration_number, uniqueness: true
    validates :registration_number, cnpj: true

    def cnpj_formatted
        cnpj = CNPJ.new(registration_number)
        cnpj.formatted
    end

    def full_description
        "#{corporate_name} (CNPJ:#{cnpj_formatted})"
    end
end
