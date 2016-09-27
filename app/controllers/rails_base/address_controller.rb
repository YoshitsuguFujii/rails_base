class RailsBase::AddressController < RailsBase::ApplicationController
  def show
    address = ZipCodeJp.find(params[:id])
    if address
      render json: {result: "success", object: address.as_json}
    else
      render json: {result: "not found", object: nil}
    end
  end
end
