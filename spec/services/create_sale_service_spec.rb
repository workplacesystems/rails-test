require 'rails_helper'
describe CreateSaleService do

  describe '#create' do

    subject { described_class.new.create(data) }

    let(:data) { {} }

    it 'creates a new Sale and calls save on it' do
      fake_sale = double(save: false)
      expect(Sale).to receive(:new).with(data).and_return(fake_sale)
      expect(fake_sale).to receive(:save).once
      subject
    end

    it 'return hash with id and password' do
      fake_sale = double(save: true, id: 123, generated_password: 'genpass')
      expect(Sale).to receive(:new).with(data).and_return(fake_sale)
      expect(fake_sale).to receive(:save).once
      expect(subject).to eq({ id: 123, password: 'genpass' })
    end
  end
end
