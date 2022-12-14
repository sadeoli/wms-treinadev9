class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :supplier
  belongs_to :user
  has_many :order_items
  has_many :product_models, through: :order_items

  enum status: { pending: 0, delivered: 5, canceled: 9}

  validates :code, :warehouse, :supplier, :user, :estimated_delivery_date, presence: true
  validates :code, format: { with: /[A-Z0-9]{10}/ }
  validate :estimated_delivery_date_is_future

  before_validation :generate_code, on: :create 



  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end

  def estimated_delivery_date_is_future
    if self.estimated_delivery_date.present? && self.estimated_delivery_date <= Date.today
      self.errors.add(:estimated_delivery_date, " deve ser futura.")
    end
  end

  def deliver_order
    order_items.each do |item|
      item.quantity.times do
          StockProduct.create!(order:self, warehouse:warehouse, product_model:item.product_model)
      end
    end
  end

end
