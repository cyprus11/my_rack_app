class App
  ALLOW_PATH = '/time'
  TIME_FORMAT = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }

  def call(env)
    handle_request(env)
    [status, headers, body]
  end

  private

  def status
    @status
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def body
    [@body]
  end

  def handle_request(env)
    if env['PATH_INFO'] != ALLOW_PATH
      @status = 404
      @body = "Wrong path\n"
      return
    end

    query_string = env['QUERY_STRING']

    if query_string.start_with?('format=')
      query_attributes = query_string.delete_prefix('format=')
      prevent_attributes = query_attributes.scan(/\w+/) - TIME_FORMAT.keys.map(&:to_s)

      if prevent_attributes.any?
        @status = 400
        @body = "Unknown time format [#{prevent_attributes.join(', ')}]\n"
      else
        @status = 200
        TIME_FORMAT.keys.each do |key|
          query_attributes.gsub!(key.to_s, TIME_FORMAT[key])
        end
        query_attributes += "\n"

        @body = Time.new.strftime(query_attributes)
      end
    else
      @status = 400
      @body = "Unknown query"
    end
  end
end