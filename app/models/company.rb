# == Schema Information
#
# Table name: companies
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
#  name                   :string
#  zip_code               :string
#  phone                  :string
#  description            :text
#  url                    :string
#  latitude               :float
#  longitude              :float
#  address                :string
#  city                   :string
#  state                  :string
#  service_radius         :float
#  status                 :string           default("Pending")
#
# Indexes
#
#  index_companies_on_email                 (email) UNIQUE
#  index_companies_on_reset_password_token  (reset_password_token) UNIQUE
#

class Company < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :company_services
  has_many :service_categories, through: :company_services
  has_many :reviews
  has_many :customers, through: :reviews
  has_many :quotes

  geocoded_by :full_street_address
  after_validation :geocode

  def shorten_zip_code
    zip_code[0..4]
  end

  def eligible_customer_requests
    CustomerRequest.where("expires_date >= ?", Date.today()).where(
      service_category_id: service_categories
    ).select {|cr| cr.distance_from([latitude, longitude]) <= service_radius }
  end

  def open_quotes
    quotes.where(accepted: nil)
  end

  def accepted_quotes
    quotes.where(accepted: true)
  end
  
  private

  def full_street_address
    "#{address}, #{city}, #{state}, #{zip_code}"
  end

end
