class SalesController < ApplicationController
  include Sales::ControllerConcern
  respond_to :json
  def create
    @sale = Sale.create(safe_params[:sales])

  end
  def show

  end
  def destroy

  end

  private
end
