class SalesController < ApplicationController
  include Sales::ControllerConcern
  respond_to :json

  def create
    @sales = Sale.create(safe_params[:sales])
    @sales = [@sales] unless @sales.instance_of? Array
    render :show

  end
  def show
    @sales = [Sale.find_secure(params[:id], digested_password)]
  end
  def destroy
    @sales = [Sale.find_secure(params[:id], digested_password).destroy]
    render :show

  end
  rescue_from Exception do |exception|
    @sales = []
    @exception = exception
    status = case
               when exception.is_a?(ActiveRecord::RecordNotFound)
                 404
               else
                 500
             end
    render :error, :status => status

  end
  private
end
