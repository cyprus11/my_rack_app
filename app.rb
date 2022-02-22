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
      return false
    end

    true
  end

  def handle_query_string(query_string)
    if query_string.start_with?("format=")
      @query_attributes = query_string.delete_prefix("format=")
      handle_attributes(@query_attributes)
    else
      @status = 400
    end
  end

  def handle_attributes(query_attributes)
    @prevent_attributes = query_attributes.scan(/\w+/) - TimeFormatter::TIME_FORMAT.keys.map(&:to_s)

    if @prevent_attributes.any?
      @status = 400
    else
      @status = 200
    end
  end

  def body
    if @status == 404
      "Wrong path\n"
    elsif @status == 400 && @prevent_attributes.any?
      "Unknown time format [#{@prevent_attributes.join(", ")}]\n"
    elsif @status == 400
      "Wrong request\n"
    else
      TimeFormatter.time_by_format(@query_attributes)
    end
  end

  def response
    Rack::Response.new(body, @status, headers).finish
  end
end
