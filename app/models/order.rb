class Order < ActiveRecord::Base
  belongs_to :customer
  has_one :credit_card, dependent: :destroy
  has_one :bill_address, class_name: 'BillAddress', dependent: :destroy
  has_one :ship_address, class_name: 'ShipAddress', dependent: :destroy
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :credit_card, :allow_destroy => true
  accepts_nested_attributes_for :bill_address, :allow_destroy => true
  accepts_nested_attributes_for :ship_address, :allow_destroy => true

  validates :state, inclusion: { in: %w(in_progress shipped completed) }
  validates :state, :price, presence: true

  def update_store!(customer)
    customer.order_items.in_cart.each do |item|
      item.order_id = self.id
      item.save
      book = Book.find(item.book_id)
      book.in_stock -= item.quantity
      book.save
    end
  end

  def decrease_in_stock!
    order_items.each do |item|
      book = Book.find(item.book_id)
      book.in_stock -= item.quantity
      book.save!
      end
  end

  def return_in_stock!
    order_items.each do |item|
      book = Book.find(item.book_id)
      book.in_stock += item.quantity
      book.save!
    end
  end

  def complete!
    if self.state == "shipped"
      self.completed_at = Date.today
      self.state = "completed"
      save!
    end
  end

  def shipped!
    if self.state == "in_progress"
      self.state = "shipped"
      save!
    end
  end
end

