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
        expect(sale).to be_a Sale
      end

    end
    it "Renders the show template" do
      expect(response).to render_view(:show)
    end
  end
  context "Create" do
    let(:sale_1) {{:date => '20140103', :time => '0700', :code => "FL", :value => '2.00'}}
    let(:sale_2) {{:date => '20140103', :time => '0815', :code => "DO", :value => '1.00'}}
    context "With a single sale" do
      before :each do
        expect(Sale).to receive(:create).with([{:date => '201401030700', :code => 'FL', :value => '2.00'}])
        post :create, {:sales => sale_1}
      end
      it_behaves_like "A collection of sales resources"
    end
    context "With multiple sales" do
      before :each do
        expect(Sale).to receive(:create).with([{:date => '201401030700', :code => 'FL', :value => '2.00'}, {:date => '201401030815', :code => 'DO', :value => '1.00'}])
        post :index, {:sales => [sale_1, sale_2]}
      end
      it_behaves_like "A collection of sales resources"
    end
  end
  context "Show" do
    let(:mock_sale) {instance_double('Sale', :date => Time.parse('3 January 2014 07:00:00'), :code => 'FL', :value => 2.0)}
    before :each do
      expect(Sale).to receive(:find).and_return mock_sale
    end
    it_behaves_like "A collection of sales resources"
  end
  context "Delete" do
    let(:mock_sale) {instance_double('Sale', :date => Time.parse('3 January 2014 07:00:00'), :code => 'FL', :value => 2.0)}
    before :each do
      expect(Sale).to receive(:find).with("1").and_return mock_sale
      expect(mock_sale).to receive(:destroy).and_return mock_sale
      delete :destroy, :id => 1
    end
    it_behaves_like "A collection of sales resources"
  end


end
