require 'rails_helper'

RSpec.describe "Sales rest endpoints", :type => :request do
  let :example_sale_attributes do
    {:date => Time.parse('1 November 2010 13:31:00'), :value => 1.50, :code => 'TEST', :hashed_password => Digest::MD5.hexdigest('password')}
  end

  describe "POST /sales" do
    let :plural_json do
      {
          sales: [
              {
                  date: '20140103',
                  time: '0700',
                  code: 'FL',
                  value: '2.00'
              },
              {
                  date: '20140103',
                  time: '0815',
                  code: 'DO',
                  value: '1.00'
              }
          ]
      }
    end
    let :singular_json do
      {
          sales: {
              date: '20140103',
              time: '0700',
              code: 'FL',
              value: '2.00'
          }
      }
    end

    it "Should create a single sale" do
      expect {post '/sales.json', singular_json, {'password' => "password"}}.to change(Sale, :count).by 1
      expect(response.status).to be(200)
      response_data = ActiveSupport::JSON.decode(response.body).with_indifferent_access
      #Verify the response data.  It should have 'sales' as the root item and an array of items even if only 1.
      # This was decided upon to make the user interface code simpler and would normally have been decided
      # with the UI developer(s) if it wasnt specified in the requirements.
      expect(response_data[:sales].length).to eq(1)
      created_sale = Sale.find(response_data[:sales].first['id'])
      expect(created_sale.date).to eq(Time.parse('3 January 2014 07:00:00'))
      expect(created_sale.value).to eq(2.0)
      expect(created_sale.code).to eq('FL')
    end
    it 'Should create multiple sales' do
      expect {post '/sales.json', plural_json, {'password' => "password"}}.to change(Sale, :count).by 2
      expect(response.status).to be(200)
      response_data = HashWithIndifferentAccess.new HashWithIndifferentAccess.new ActiveSupport::JSON.decode(response.body)
      #Verify the response data.  It should have 'sales' as the root item and an array of items.
      expect(response_data[:sales].length).to eq(2)
      first_created_sale = Sale.find(response_data[:sales].first[:id])
      second_created_sale = Sale.find(response_data[:sales][1][:id])
      expect(first_created_sale.date).to eq(Time.parse('3 January 2014 07:00:00'))
      expect(first_created_sale.value).to eq(2.0)
      expect(first_created_sale.code).to eq('FL')
      expect(second_created_sale.date).to eq(Time.parse('3 January 2014 08:15:00'))
      expect(second_created_sale.value).to eq(1.0)
      expect(second_created_sale.code).to eq('DO')
    end

  end
  describe "GET /sales/:id" do
    it 'Should read a specific sale if the password is correct' do
      sale = Sale.create example_sale_attributes
      get "/sales/#{sale.id}.json", nil, {'password' => "password"}
      expect(response.status).to be(200)
      expect(ActiveSupport::JSON.decode(response.body).with_indifferent_access).to include({:sales => [{:date => '20101101', :time => '1331', :code => 'TEST', :value => '1.50', :id => a_string_matching(/^\d+$/)}]})
    end
    it 'Should not read a specific sale if the password is wrong' do
      sale = Sale.create example_sale_attributes
      get "/sales/#{sale.id}.json", nil, {'password' => "wrongpassword"}
      expect(response.status).to be(404)
      expect(ActiveSupport::JSON.decode(response.body).with_indifferent_access).to include({:sales => [], :exception => {:message => "Record not found"}})
    end
    it 'Should not read a specific sale if the password is missing' do
      sale = Sale.create example_sale_attributes
      get "/sales/#{sale.id}.json"
      expect(response.status).to be(404)
      expect(ActiveSupport::JSON.decode(response.body).with_indifferent_access).to include({:sales => [], :exception => {:message => "Record not found"}})
    end

  end
  describe "DELETE /sales/:id" do
    it 'Should delete a specific sale if the password is correct' do
      sale = Sale.create example_sale_attributes
      expect {delete "/sales/#{sale.id}.json", nil, {'password' => "password"}}.to change(Sale, :count).by -1
      expect(response.status).to be(200)
      expect(Sale.where(:id => sale.id).count).to eq(0)
    end
    it 'Should not delete a specific sale if the password is wrong' do
      sale = Sale.create example_sale_attributes
      expect {delete "/sales/#{sale.id}.json", nil, :password => "wrongpassword"}.to change(Sale, :count).by 0
      expect(response.status).to be(404)
      expect(Sale.where(:id => sale.id).count).to eq(1)
    end

  end
end
