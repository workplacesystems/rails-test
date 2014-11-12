require 'spec_helper'

describe Sale do

  context 'the colum names' do
    subject { Sale.column_names }
    it { include :date }
    it { include :time }
    it { include :code }
    it { include :value }
    it { include :password_hash }
  end

  it 'applys random 8 character password and hashes it' do
    sale = Sale.new
    expect( length(sale.password) ).to > 10
    expect( length(sale.password_hash) ).to > 10
  end
end
