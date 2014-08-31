require 'rails_helper'
# The sales controller is designed to suit the UI interface given in that
#  it can handle single singular or multiple resources on create.
#  This is reflected in the output as well in that the show view will be
#  used on create, show and delete and it will be presented with an array
#  of resources even if there is only 1.
#  This is an assumption and would normally have been agreed with the interested parties
#  as it is not clear in the specification.
RSpec.describe SalesController, :type => :controller do
  shared_examples "A collection of sales resources" do
    it "Assigns @sales" do
      expect(assigns(:sales)).to be_an Array
      assigns(:sales).each do |sale|
        #Ensure each sale quacks like a sale
        expect(sale).to respond_to(:date)
        expect(sale).to respond_to(:code)
        expect(sale).to respond_to(:value)
      end

    end
    it "Renders the show template" do
      expect(response).to render_template(:show)
    end
  end
  shared_examples "An error with status" do |status|
    it "Should respond with an error status of #{status}" do
      expect(assigns(:sales)).to eq([])
      expect(assigns(:exception)).to be_an Exception
      expect(response.status).to eq(status)
      expect(response).to render_template(:error)
    end

  end
  let(:hashed_password) {Digest::MD5.hexdigest("password")}
  context "Create" do
    let(:sale_1) {{:date => '20140103', :time => '0700', :code => "FL", :value => '2.00'}}
    let(:sale_2) {{:date => '20140103', :time => '0815', :code => "DO", :value => '1.00'}}
    let(:sale_1_model) {double('Sale', :date => '201401030700', :code => "FL", :value => 2.0)}
    let(:sale_2_model) {double('Sale', :date => '201401030815', :code => "DO", :value => 1.0)}
    context "With a single sale" do
      before :each do
        expect(Sale).to receive(:create).with([{:date => '201401030700', :code => 'FL', :value => '2.00', :hashed_password => hashed_password}]).and_return sale_1_model
        request.headers['password'] = "password"
        post :create, {:sales => sale_1}
      end
      it_behaves_like "A collection of sales resources"
    end
    context "With multiple sales" do
      before :each do
        expect(Sale).to receive(:create).with([{:date => '201401030700', :code => 'FL', :value => '2.00', :hashed_password => hashed_password}, {:date => '201401030815', :code => 'DO', :value => '1.00', :hashed_password => hashed_password}]).and_return [sale_1_model, sale_2_model]
        request.headers['password'] = "password"
        post :create, {:sales => [sale_1, sale_2]}
      end
      it_behaves_like "A collection of sales resources"
    end
  end
  context "Show" do
    context "With positive response" do
      let(:mock_sale) {double('Sale', :date => Time.parse('3 January 2014 07:00:00'), :code => 'FL', :value => 2.0, :hashed_password => hashed_password)}
      before :each do
        expect(Sale).to receive(:find_secure).with("1", hashed_password).and_return mock_sale
        request.headers['password'] = "password"
        get :show, {:id => "1"}
      end
      it_behaves_like "A collection of sales resources"
    end
    #A negative response is to return an empty array in sales
    #and a status of false in the JSON response.
    #This would normally be agreed with the UI developer(s), but in this case I am making an assumption
    #that the UI would not want to be parsing an HTML error page.
    context "With negative response" do
      context "Record not found" do
        before :each do
          expect(Sale).to receive(:find_secure).with("2", hashed_password).and_raise(ActiveRecord::RecordNotFound)
          request.headers['password'] = "password"
          get :show, {:id => "2"}
        end
        it_behaves_like "An error with status", 404
      end
      context "A different exception" do
        before :each do
          expect(Sale).to receive(:find_secure).with("2", hashed_password).and_raise(ActiveRecord::AdapterNotFound)
          request.headers['password'] = "password"
          get :show, {:id => "2"}
        end
        it_behaves_like "An error with status", 500
      end
    end
  end
  context "Delete" do
    context "With positive response" do
      let(:mock_sale) {double('Sale', :date => Time.parse('3 January 2014 07:00:00'), :code => 'FL', :value => 2.0)}
      before :each do
        expect(Sale).to receive(:find_secure).with("1", hashed_password).and_return mock_sale
        expect(mock_sale).to receive(:destroy).and_return mock_sale
        request.headers['password'] = "password"
        delete :destroy, {:id => 1}
      end
      it_behaves_like "A collection of sales resources"
    end
    context "With negative response" do
      context "Record not found" do
        before :each do
          expect(Sale).to receive(:find_secure).with("2", hashed_password).and_raise(ActiveRecord::RecordNotFound)
          request.headers['password'] = "password"
          delete :destroy, {:id => "2"}
        end
        it_behaves_like "An error with status", 404
      end
      context "Any other exception" do
        before :each do
          expect(Sale).to receive(:find_secure).with("2", hashed_password).and_raise(ActiveRecord::AdapterNotFound)
          request.headers['password'] = "password"
          delete :destroy, {:id => "2"}
        end
        it_behaves_like "An error with status", 500
      end
    end
  end


end
