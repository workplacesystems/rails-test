json.sales do
  json.array! @sales do |sale|
    json.date sale.date.strftime('ymd')
    json.time sale.date.strftime('hm')
    json.code sale.code
    json.value sale.value.to_s
  end
end
