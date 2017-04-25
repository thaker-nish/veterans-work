# == Schema Information
#
# Table name: customer_requests
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  address             :string
#  city                :string
#  state               :string
#  zipcode             :string
#  service_category_id :integer
#  description         :text
#  customer_id         :integer
#  expires_date        :date
#  latitude            :float
#  longitude           :float
#
# Indexes
#
#  index_customer_requests_on_expires_date  (expires_date)
#

require 'rails_helper'

RSpec.describe CustomerRequestsController, type: :controller do
  describe 'GET #index' do
    context 'company signed in' do

      before :each do
        sign_in create :company
      end

      it 'assigns all eligible customer request to @requests' do
        all_requests = [
          create(:customer_request),
          create(:customer_request)
        ]
        allow_any_instance_of(Company).to receive(:eligible_customer_requests).and_return(all_requests)
        get :index
        expect(assigns(:requests)).to eq(all_requests)
      end

      it 'renders the index html' do
        get :index
        expect(response).to render_template("index.html.erb")
      end
    end

    context 'company not signed in' do
      it 'redirects to the company sign in page' do
        get :index
        expect(response).to redirect_to('/companies/sign_in')
      end
    end
  end

  describe 'GET #new' do
    context 'customer signed in' do

      before :each do
        sign_in create :customer
      end

      it 'should create a new customer request' do
        get :new
        expect(assigns(:customer_request)).to be_a_new(CustomerRequest)
      end

      it 'assigns all service categories to @categories' do
        all_categories = [
          create(:service_category),
          create(:service_category)
        ]
        get :new
        expect(assigns(:categories)).to eq(all_categories)
      end

      it 'renders the new html' do
        get :new
        expect(response).to render_template("new.html.erb")
      end
    end

    context 'customer not signed in' do
      it 'redirects to the customer sign in page' do
        get :new
        expect(response).to redirect_to('/customers/sign_in')
      end
    end
  end

  describe 'POST #create' do
    it 'creates and saves a new customer request to the database' do
      sign_in create(:customer)
      expect{
        post :create, params: { customer_request: attributes_for(:customer_request) }
      }.to change(CustomerRequest, :count).by(1)
    end
    it 'redirects to the customer_requests index' do
      customer = create(:customer)
      sign_in customer
      post :create, params: { customer_request: attributes_for(:customer_request) }
      expect(response).to redirect_to("/customers/#{customer.id}")
    end
  end

  describe 'GET #show' do

    before :each do
      @customer_request = create(:customer_request)
    end

    context 'company signed in' do

      before :each do
        sign_in create :company
      end

      it 'assigns the requested customer_request to @request' do
        get :show, params: { id: @customer_request.id }
        expect(assigns(:request)).to eq(@customer_request)
      end

      it 'renders the show page' do
        get :show, params: { id: @customer_request.id }
        expect(response).to render_template('show.html.erb')
      end
    end

    context 'customer signed in' do
      it 'assigns current customer\'s customer_request to @request' do

      end
    end
  end

  describe 'GET #edit' do
    it '' do
    end
    it '' do
    end
  end

  describe 'PATCH #update' do
    it '' do
    end
    it '' do
    end
  end

  describe 'DELETE #destroy' do
    it '' do
    end
    it '' do
    end
  end
end
