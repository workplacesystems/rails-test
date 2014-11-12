require 'rails_helper'
describe SalesController do

  context 'sending a POST request' do
    describe '#create' do
      before do
        controller.load_create_sale_service(fake_service)
      end
      let(:fake_service) { double }
      let(:expected_sale) { build :sale }

      let(:sale_data) do
        { date: '20140103',
          time: '0815',
          code: 'DO',
          value: '1.00' }
      end

      context 'multiple sales' do
        let(:params) do
          { format: :json, sales: [ sale_data, sale_data_2 ] }
        end
        let(:sale_data_2) do
          { date: '20140104' }
        end

        it 'calls the service with parsed data' do
          faked_data = [{"id"=>123, "password"=>"pass1"}, {"id"=>321, "password"=>"pass2"}]
          expect(fake_service).to receive(:create_multiple).
                                  with([sale_data, sale_data_2]).
                                  once.and_return(faked_data)
          post :create, params
          expect(json).to eq faked_data
        end
      end

      context 'singular sale' do
        let(:params) do
          { format: :json, sale: sale_data }
        end

        it 'calls the service with parsed data' do
          expect(fake_service).to receive(:create_multiple).with([sale_data]).once
          post :create, params
        end
      end
    end
  end

  context 'sending a GET request' do
    describe '#show' do
      before do
        controller.load_retrieve_sale_service(fake_service)
      end
      let(:fake_service) { double }
      let(:expected_sale) { build :sale }

      it 'passes id and password to retrieve service' do
        expect(fake_service).to receive(:load).with('123', 'pass').and_return(expected_sale)
        get :show, { format: :json, id: 123, password: 'pass' }
        expect(json).to include('code', 'date', 'id', 'time', 'value')
      end
    end
  end

  context 'a sale exists' do

    let(:sale1) { create :sale }
    before { sale1 }

    context 'sending a DELETE request' do
      describe '#destroy' do
        subject { delete :destroy, params }
        let(:params) { { format: :json, id: sale1.id } }
        it 'deletes the sale' do
          expect { subject }.to change(Sale, :count).by(-1)
        end
      end
    end
  end
end
