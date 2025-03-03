class Rack::Attack
  # Throttle all requests by IP (100 requests per minute)
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  # Throttle specific endpoint (10 requests per minute for the lines#show endpoint)
  throttle('lines/show', limit: 10, period: 1.minute) do |req|
    if req.path == '/api/v1/lines' && req.params['id'].present?
      req.ip
    end
  end

  # Custom response when throttled
  self.throttled_response = lambda do |env|
    [429, {}, [{ error: "Too many requests. Please try again later." }.to_json]]
  end
end
