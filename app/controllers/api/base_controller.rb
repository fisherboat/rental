class Api::BaseController < ActionController::API



  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {errors: "Not find record"}, status: 404
  end


  def formate_response_errors(errors)
    errors.messages.inject({}){|h, (k, v)| h[k] = v.join(", "); h}
  end

end