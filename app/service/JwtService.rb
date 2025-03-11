class JwtService
  SECRET_KEY = "hellowwworld"

  def self.encode(payload, expiration)
    payload[:exp] = expiration.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
      HashWithIndifferentAccess.new(decoded.first)
    rescue JWT::DecodeError => e
      puts "Decode error: #{e.message}"
      nil
    rescue => e
      puts "Other error: #{e.class.name} - #{e.message}"
      nil
    end
  end
end
