require 'rails_helper'
describe SalesController do

  context 'sending a POST request' do
    describe '#create' do
      subject { post :create, params }

      context 'multiple sales' do
        let(:params) do
          { format: :json,
            sales: [ { date: '20140103',
                       time: '0700',
                       code: 'FL',
                       value: '2.00' },
                     { date: '20140103',
                       time: '0815',
                       code: 'DO',
                       value: '1.00' } ] }
        end

        it 'creates multiple records' do
          expect { subject }.to change(Sale, :count).by(2)
        end

        it 'responds correctly and includes id with an access password' do
          subject
          expect(response).to be_success
          expect(json.count).to eq 2
          expect(json.first['id']).to be_an Integer
        end
      end

      context 'singular sale' do
        let(:params) do
          { format: :json,
            sale: { date: '20140103',
                    time: '0700',
                    code: 'FL',
                    value: '3.00' } }
        end
        it 'does not except html' do
          expect { get :create, params.merge(format: :html) }.to raise_error(ActionController::UnknownFormat )
        end
        it 'creates a single record' do
          expect { subject }.to change(Sale, :count).by(1)
        end
        it 'responds correctly and includes id with an access password' do
          subject
          expect(response).to be_success
          expect(json).to include('id')
          #expect(json).to include('password')
        end
      end
    end
  end

  context 'a sale exists' do

    let(:sale1) { create :sale }
    before { sale1 }

    context 'sending a GET request' do
      describe '#show' do

        context 'with correct password' do
          let(:params) { { format: :json, id: sale1.id, password: sale1.generated_password } }
          it 'allows access' do
            get :show, params
            expect(response).to be_success
            expect(json['id']).to eq sale1.id
            expect(json).to include('date','time','code','value')
          end
          it 'does not except html' do
            expect { get :show, params.merge(format: :html) }.to raise_error(ActionController::UnknownFormat )
          end
        end

        context 'with incorrect password' do
          let(:params) { { format: :json, id: sale1.id, password: 'dontletmein' } }
          it 'denies access' do
            get :show, params
            expect(response).not_to be_success
          end
        end
      end
    end

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
