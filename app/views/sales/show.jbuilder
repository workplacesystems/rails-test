json.sales do
  json.array! @sales do |sale|
    json.date sale.date.strftime('%Y%m%d')
    json.time sale.date.strftime('%H%M')
    json.code sale.code
    json.value number_with_precision sale.value, :precision => 2
  end
end