class AuthenticationService
    ACCESS_TOKEN_EXPIRY = 30.minutes
    REFRESH_TOKEN_EXPIRY = 1.days
  
    def initialize(user)
      @user = user
    end
  
    def generate_access_token
      JwtService.encode({ user_id: @user.id, type: "access" }, ACCESS_TOKEN_EXPIRY.from_now)
    end
  
    def generate_refresh_token
      token = JwtService.encode({ user_id: @user.id, type: "refresh" }, REFRESH_TOKEN_EXPIRY.from_now)
  
      token
    end
  end