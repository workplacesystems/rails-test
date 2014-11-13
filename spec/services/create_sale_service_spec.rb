require 'rails_helper'
describe CreateSaleService do

  let(:service) { described_class.new }

  describe '#create_multiple' do
    subject { service.create_multiple(list) }

    let(:list) { [ {}, {} ] }

    it 'passes each item to #create' do
      expect(service).to receive(:create).twice
      subject
    end
  end

  describe '#create' do

    subject { service.create(data) }

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
