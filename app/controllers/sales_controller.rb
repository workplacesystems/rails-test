class SalesController < ApplicationController
  include Sales::ControllerConcern
  respond_to :json
  def create
    @sales = Sale.create(safe_params[:sales])
    @sales = [@sales] unless @sales.instance_of? Array
    render :show

  end
  def show

  end
  def destroy

  end

  private
end
