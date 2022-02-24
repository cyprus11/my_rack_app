class App
  ALLOW_PATH = "/time"
  ALLOW_REQUEST_PREFIX = 'format='

  def call(env)
    status, body = handle_request(env)
    response(status, body)
  end

  private

  def headers
    { "Content-Type" => "text/plain" }
  end

  def handle_request(env)
    return wrong_path if env['REQUEST_PATH'] != ALLOW_PATH
    return wrong_request unless env['QUERY_STRING'].start_with?(ALLOW_REQUEST_PREFIX)

    request_time(env['QUERY_STRING'].delete_prefix(ALLOW_REQUEST_PREFIX))
  end

  def wrong_path
    status = 404
    body = "Wrong path\n"

    [status, body]
  end

  def wrong_request
    status = 400
    body = "Wrong request\n"

    [status, body]
  end

  def request_time(string)
    time_formatter = TimeFormatter.new(string)
    status = time_formatter.success? ? 200 : 400
    body = time_formatter.call

    [status, body]
  end

  def response(status, body)
    Rack::Response.new(body, status, headers).finish
  end
end
