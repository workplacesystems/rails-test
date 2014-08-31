require 'rails_helper'

RSpec.describe Sale, :type => :model do
  it 'Should store the date, code and value fields' do
    new_sale = Sale.create! :date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25
    retrieved_sale = Sale.find(new_sale.id)
    expect(retrieved_sale.date).to eq(Time.parse('1 January 2013 09:00:00'))
    expect(retrieved_sale.code).to eq('TEST')
    expect(retrieved_sale.value).to eq(10.25)
  end
end
