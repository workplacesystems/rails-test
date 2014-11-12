class CreateSaleService
  def create(data)
    sale = Sale.new data
    sale.save ? { id: sale.id, password: sale.generated_password } : nil
  end
end
