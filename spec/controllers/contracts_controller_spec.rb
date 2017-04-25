# == Schema Information
#
# Table name: contracts
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  quote_id            :string
#  customer_request_id :string
#

require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  describe 'POST #create' do
    before :each do
      @company_one = create(:company)
      @company_two = create(:company)
      @company_three = create(:company)
      @customer = create(:customer)
      sign_in @customer
      @customer_request = create(:customer_request, customer_id: @customer.id)
      @quote_one = create(
        :quote,
        company_id: @company_one.id,
        customer_request_id: @customer_request.id
      )
      @quote_two = create(
        :quote,
        company_id: @company_two.id,
        customer_request_id: @customer_request.id
      )
      @quote_three = create(
        :quote,
        company_id: @company_three.id,
        customer_request_id: @customer_request.id
      )
    end

    it 'creates and saves a new contract to the database' do
      expect{
        post :create, params: {
          id: @quote_one.id
          }
        }.to change(Contract, :count).by(1)
    end

    it 'sends an email to each company that has created a quote' do
      expect {
        post :create, params: {
          id: @quote_one.id
        }
      }.to change { ActionMailer::Base.deliveries.count }.by(3)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested contract to @contract' do
      @company_one = create(:company)
      @company_two = create(:company)
      @company_three = create(:company)
      @customer = create(:customer)
      sign_in @customer
      @customer_request = create(:customer_request, customer_id: @customer.id)
      @quote_one = create(
        :quote,
        company_id: @company_one.id,
        customer_request_id: @customer_request.id,
        accepted: true
      )
      @quote_two = create(
        :quote,
        company_id: @company_two.id,
        customer_request_id: @customer_request.id,
        accepted: nil
      )
      @quote_three = create(
        :quote,
        company_id: @company_three.id,
        customer_request_id: @customer_request.id,
        accepted: nil
      )
      @contract = create(
        :contract,
        customer_request_id: @customer_request.id,
        quote_id: @quote_one.id
      )
      get :show, params: { id: @contract.id }
      expect(assigns(:contract)).to eq(@contract)
    end
    it 'redirects to show page if not logged in as current Company or Customer' do
      @contract = create(
        :contract,
        customer_request_id: 5,
        quote_id: 1
      )
      get :show, params: { id: @contract.id }
      expect(response).to redirect_to('/')
    end
  end
end
