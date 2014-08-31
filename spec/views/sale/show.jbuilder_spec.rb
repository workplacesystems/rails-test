require "rails_helper"

describe "sales/show" do
  let(:sale_1) {{:date => '201301030700', :code => 'FL', :value => 2.0}}
  let(:sale_2) {{:date => '201301030815', :code => 'DO', :value => 1.0}}
  it "displays all the sales" do
    assign(:sales, [
        Sale.create!(sale_1),
        Sale.create!(sale_2),
    ])
    render
    decoded =ActiveSupport::JSON.decode(rendered).with_indifferent_access
    expect(decoded[:sales]).to be_an Array
    expect(decoded[:sales][0]).to include({'date' => '20130103', 'time' => '0700', 'code' => 'FL', 'value' => '2.00', 'id' => a_string_matching(/^\d*$/)})
    expect(decoded[:sales][1]).to include({'date' => '20130103', 'time' => '0815', 'code' => 'DO', 'value' => '1.00', 'id' => a_string_matching(/^\d*$/)})
  end
end