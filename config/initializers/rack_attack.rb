class Rack::Attack
  # Throttle all requests by IP (100 requests per minute)
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  # Custom response when throttled
  self.throttled_response = lambda do |env|
    [429, {}, [{ error: "Too many requests. Please try again later." }.to_json]]
  end
end
