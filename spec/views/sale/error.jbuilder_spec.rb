require "rails_helper"

describe "sales/error" do
  it "displays details of the error and an empty record set" do
    assign(:sales, [])
    assign(:exception, ActiveRecord::RecordNotFound.new("Record not found"))
    render
    decoded =HashWithIndifferentAccess.new ActiveSupport::JSON.decode(rendered)
    expect(decoded[:sales]).to eq([])
    expect(decoded[:exception]).to eq({"message"=>"Record not found"})
  end
end
