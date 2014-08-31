# The controller for the sales resource
class SalesController < ApplicationController
  include Sales::ControllerConcern
  respond_to :json
  skip_before_filter :verify_authenticity_token
  # Maps to /sales.json with method of POST
  # Accepts :sales as either an array of attributes to build the sale or a single object containing the
  # attributes for a single sale.
  # The password used to retrieve the sale should be in the 'password' header.
  def create
    @sales = Sale.create(safe_params[:sales])
    @sales = [@sales] unless @sales.instance_of? Array
    render :show
  end
  # Maps to /sales/:id.json with method of GET
  # Shows the sale as a JSON object.
  # Must have the 'password' header set to the password saved when created
  def show
    @sales = [Sale.find_secure(params[:id], digested_password)]
  end
  # Maps to /sales/:id.json with method of DELETE
  # Deletes the sale and returns the deleted sale
  # Must have the 'password' header set to the password saved when created
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
end
