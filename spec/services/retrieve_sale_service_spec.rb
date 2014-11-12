require 'rails_helper'
describe RetrieveSaleService do

  describe '#load' do

    subject { described_class.new.load(id, password) }

    let(:id) { 123 }
    let(:password) { 'password' }

    it 'loads a Sale via the id' do
      expect(Sale).to receive(:find).with(id)
      subject
    end

    it 'returns the sale if the password matches' do
      sale = double( password: password)
      allow(Sale).to receive(:find).and_return(sale)
      expect(subject).to eq sale
    end

    it 'returns nil sale if the password does not match' do
      sale = double(password: 'adifferentpassword')
      allow(Sale).to receive(:find).and_return(sale)
      expect(subject).to eq nil
    end

  end
end
