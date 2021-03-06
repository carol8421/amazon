class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :orders, dependent: :destroy
  has_one :credit_card, dependent: :destroy
  has_one :customer_bill_address, class_name: 'CustomerBillAddress', dependent: :destroy
  has_one :customer_ship_address, class_name: 'CustomerShipAddress', dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_and_belongs_to_many :wishes, class_name: 'Book'
  
  validates :email, format: { with: /\A.+@.+\z/ }, uniqueness: true, presence: true

  def did_not_rate?(book_id)
    ratings.where(book_id: book_id).empty?
  end

  def self.find_for_facebook_oauth access_token
    if customer = Customer.where(:url => access_token.info.urls.Facebook).first
      customer
    else 
      Customer.create!(:provider => access_token.provider, :url => access_token.info.urls.Facebook, :email => access_token.extra.raw_info.email, :password => Devise.friendly_token[0,20]) 
    end
  end
end
