# == Schema Information
#
# Table name: customers
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_customers_on_email                 (email) UNIQUE
#  index_customers_on_reset_password_token  (reset_password_token) UNIQUE
#

class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews
  has_many :companies, through: :reviews
  has_many :customer_requests
  has_many :quotes, through: :customer_requests


  def open_quotes
    quotes = []
    customer_requests.each do |cr|
      cr.quotes.each do |quote|
        if quote.accepted == nil
          quotes << quote
        end
      end
    end
    quotes
  end

  def accepted_quotes
    quotes = []
    customer_requests.each do |cr|
      cr.quotes.each do |quote|
        if quote.accepted
          quotes << quote
        end
      end
    end
    quotes
  end

end
