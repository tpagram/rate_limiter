class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def rate_limit max_requests, limit_duration
    ip = request.remote_ip

    if !$redis.exists ip
      $redis.multi do
        $redis.set ip, 1
        $redis.expire ip, limit_duration.to_i
      end
    else
      $redis.incr ip
      if ($redis.get ip).to_i > max_requests
        render status: 429, json: {error: "Rate limit exceeded. Try again in #{$redis.ttl ip} seconds"}
      end
    end
  rescue
    render status: 500, json: {error: "Internal server error"}
  end
end
