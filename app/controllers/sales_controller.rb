class SalesController < ApplicationController
  respond_to :json

  before_filter :load_retrieve_sale_service, only: [:show]
  before_filter :load_create_sale_service, only: [:create]
  before_filter :set_sale, only: [:destroy]

  def show
    sale = @retrieve_sale_service.load(params[:id], params[:password])
    respond_to do |format|
      format.json { render json: sale, except: [:password_hash, :updated_at, :created_at] }
    end
  end

  def create
    new_sales = @create_sale_service.create_multiple(sales_params)
    respond_to do |format|
      format.json { render json: new_sales }
    end
  end

  def destroy
    @sale.destroy
    respond_with(@sale)
  end

  def load_retrieve_sale_service(service = RetrieveSaleService.new)
    @retrieve_sale_service ||= service
  end

  def load_create_sale_service(service = CreateSaleService.new)
    @create_sale_service ||= service
  end

  private

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sales_params
      if params.key?(:sales)
        params.require(:sales).map do |sp|
          sp.permit(*permitted_sale_params)
        end
      else
        [ params.require(:sale).permit(*permitted_sale_params) ]
      end
    end

    def permitted_sale_params
      [:date, :time, :code, :value]
    end
end
