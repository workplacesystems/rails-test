class RetrieveSaleService
  def load(id, password)
    sale = Sale.find id
    (sale && sale.password == password) ? sale : nil
  end
end
