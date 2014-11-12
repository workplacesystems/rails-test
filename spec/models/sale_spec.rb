require 'rails_helper'
describe Sale do

  context 'the colum names' do
    subject { Sale.column_names }
    it { include :date }
    it { include :time }
    it { include :code }
    it { include :value }
    it { include :password_hash }
  end

  it 'generates an 8 character password and hash' do
    sale = Sale.new
    expect( sale.generated_password.length ).to eq 8
    expect( sale.password_hash ).to be_an String
  end
  
  it 'the generated password can be validated' do
    sale = Sale.new
    expect(sale.password == sale.generated_password).to eq true
  end
  
end
