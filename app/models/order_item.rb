class OrderItem < ApplicationRecord
  belongs_to :product_model
  belongs_to :order
  validates :quantity, numericality: {greater_than: 0}
  validates :quantity, presence:true
end
