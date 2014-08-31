require 'rails_helper'

RSpec.describe Sale, :type => :model do
  it 'Should store the date, code and value fields' do
    new_sale = Sale.create! :date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25
    retrieved_sale = Sale.find(new_sale.id)
    expect(retrieved_sale.date).to eq(Time.parse('1 January 2013 09:00:00'))
    expect(retrieved_sale.code).to eq('TEST')
    expect(retrieved_sale.value).to eq(10.25)
  end
  it 'Should convert the date from a string' do
    new_sale = Sale.create! :date => '201401030700', :code => 'TEST', :value => 10.25
    expect(new_sale.date).to eq(Time.parse('3 January 2014 07:00:00'))
  end
  it 'Should allow for creating of multiple records' do
    data = [{:date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25}, {:date => Time.parse('1 January 2013 10:00:00'), :code => 'TEST', :value => 11.25}]
    result = nil
    expect {result = Sale.create!(data)}.to change(Sale, :count).by(2)
    expect(result).to be_an Array
  end
  it 'Should allow for deleting of a single record and returning the deleted record' do
    sale = Sale.create({:date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25})
    result = sale.destroy
    expect(result).to be_a Sale
  end
end
