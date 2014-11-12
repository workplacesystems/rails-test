class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :destroy]
  respond_to :json

  def show
    set_sale
    if @sale.password == params[:password]
      respond_with(@sale)
    else
      render nothing: true, status: :unauthorized
    end
  end

  def create
    if sale_params.kind_of?(Array)
      @new_sales = sale_params.map do |sp|
        sale = Sale.new(sp.permit(:date, :time, :code, :value))
        sale.save
        sale
      end
      respond_to do |format|
        format.json { render json: @new_sales }
      end
    else
      @sale = Sale.new(sale_params)
      @sale.save
      respond_with(@sale)
    end
  end

  def destroy
    @sale.destroy
    respond_with(@sale)
  end

  private

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sale_params
      if params.key?(:sales)
        params.require(:sales)
      else
        params.require(:sale).permit(:date, :time, :code, :value)
      end
    end

end
