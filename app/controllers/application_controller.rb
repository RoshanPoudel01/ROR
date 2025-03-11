class ApplicationController < ActionController::API
  attr_reader :current_user

  def authenticate
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    payload = JwtService.decode(token)
    if payload && payload[:type] == "access"
      @current_user = User.find(payload[:user_id])
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { message: "Unauthorized" }, status: :unauthorized
  end
end
