FactoryGirl.define do
  factory :sale do
    date { 1.day.ago }
    time { 1.hour.ago }
    code { 'ABC123' }
    value { 1.99 }
  end
end

