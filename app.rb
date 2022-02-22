class App
  ALLOW_PATH = "/time"

  def call(env)
    handle_request(env)
    response
  end

  private

  def headers
    { "Content-Type" => "text/plain" }
  end

  def handle_request(env)
    return unless handle_path(env)

    handle_query_string(env["QUERY_STRING"])
  end

  def handle_path(env)
    if env["PATH_INFO"] != ALLOW_PATH
      @status = 404
      @body = "Wrong path\n"
      return false
    end

    true
  end

  def handle_query_string(query_string)
    if query_string.start_with?("format=")
      query_attributes = query_string.delete_prefix("format=")
      handle_attributes(query_attributes)
    else
      @status = 400
      @body = "Wrong request\n"
    end
  end

  def handle_attributes(query_attributes)
    prevent_attributes = query_attributes.scan(/\w+/) - TimeFormatter::TIME_FORMAT.keys.map(&:to_s)

    if prevent_attributes.any?
      @status = 400
      @body = "Unknown time format [#{prevent_attributes.join(", ")}]\n"
    else
      @status = 200
      @body = TimeFormatter.time_by_format(query_attributes)
    end
  end

  def response
    Rack::Response.new(@body, @status, headers).finish
  end
end
