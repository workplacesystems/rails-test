require 'rails_helper'

RSpec.describe Sale, :type => :model do
  it 'Should store the date, code, value and hashed_password fields' do
    new_sale = Sale.create! :date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25, :hashed_password => Digest::MD5.hexdigest('password')
    retrieved_sale = Sale.find(new_sale.id)
    expect(retrieved_sale.date).to eq(Time.parse('1 January 2013 09:00:00'))
    expect(retrieved_sale.code).to eq('TEST')
    expect(retrieved_sale.value).to eq(10.25)
    expect(retrieved_sale.hashed_password).to eq(Digest::MD5.hexdigest('password'))
  end
  it 'Should convert the date from a string' do
    new_sale = Sale.create! :date => '201401030700', :code => 'TEST', :value => 10.25, :hashed_password => Digest::MD5.hexdigest('password')
    expect(new_sale.date).to eq(Time.parse('3 January 2014 07:00:00'))
  end
  it 'Should allow for creating of multiple records' do
    data = [{:date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25, :hashed_password => Digest::MD5.hexdigest('password')}, {:date => Time.parse('1 January 2013 10:00:00'), :code => 'TEST', :value => 11.25, :hashed_password => Digest::MD5.hexdigest('password')}]
    result = nil
    expect {result = Sale.create!(data)}.to change(Sale, :count).by(2)
    expect(result).to be_an Array
  end
  it 'Should allow for deleting of a single record and returning the deleted record' do
    sale = Sale.create({:date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25, :hashed_password => Digest::MD5.hexdigest('password')})
    result = sale.destroy
    expect(result).to be_a Sale
  end
  context 'Finding a record using a simple method which finds by id and hashed_password' do
    before :each do
      new_sale = Sale.create! :date => Time.parse('1 January 2013 09:00:00'), :code => 'TEST', :value => 10.25, :hashed_password => Digest::MD5.hexdigest('password')
    end
    context "Positive response" do
      it 'Should find the record if the correct password is given' do
        expect(Sale.find_secure(new_sale.id, Digest::MD5.hexdigest('password'))).to eq(new_sale)
      end
    end
    context "Negative response" do
      it 'Should not find the record if the wrong password is given' do
        expect(Sale.find_secure(new_sale.id, Digest::MD5.hexdigest('wrongpassword'))).to raise(ActiveRecord::RecordNotFound)
      end
    end
  end

end
