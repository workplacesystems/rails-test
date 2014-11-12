require 'spec_helper'

describe SalesController do

  context 'sending a POST request' do
    describe '#create' do
      subject { post :create, params }

      context 'multiple sales' do
        let(:params) do
          { sales: [ { date: '20140103',
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
          expect(JSON.parse(response.body)).to include(:id, :password)
        end
      end

      context 'singular sale' do
        let(:params) do
          { sale: { date: '20140103',
                    time: '0700',
                    code: 'FL',
                    value: '2.00' } }
        end
        it 'creates a single record' do
          expect { subject }.to change(Sale, :count).by(1)
        end
        it 'responds correctly and includes id with an access password' do
          subject
          expect(response).to be_success
          expect(JSON.parse(response.body)).to include(:id, :password)
        end
      end
    end
  end

  context 'a sale exists' do
    let(:sale1) { create :sale }

    context 'sending a GET request' do
      describe '#show' do
        subject { get :show, params }

        context 'with correct password' do
          let(:params) { { id: sale1.id, password: sale1_password } }
          let(:sale1_password) { 'somepassword' }
          it { expect(response).to be_success }
          it { expect(JSON.parse(response.body)).to == sale1.to_json }
        end

        context 'with incorrect password' do
          let(:params) { { id: sale1.id, password: 'dontletmein' } }
          it { expect(response).not_to be_success }
        end
      end
    end

    context 'sending a DELETE request' do
      describe '#destroy' do
        subject { delete :destroy, params }
        it 'deletes the sale' do
          expect { subject }.to change(Sale, :count).by(1)
        end
      end
    end
  end

end
