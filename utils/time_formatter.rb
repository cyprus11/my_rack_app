class TimeFormatter
  TIME_FORMAT = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }

  def initialize(query_string)
    @query_string = query_string
  end

  def success?
    (@query_string.scan(/\w+/) - TIME_FORMAT.keys.map(&:to_s)).empty?
  end

  def time_string
    TIME_FORMAT.keys.each do |key|
      @query_string.gsub!(key.to_s, TIME_FORMAT[key])
    end
    @query_string += "\n"

    Time.new.strftime(@query_string)
  end

  def invalid_string
    invalid_attr = @query_string.scan(/\w+/) - TIME_FORMAT.keys.map(&:to_s)
    "Unknown time format [#{invalid_attr.join(', ')}]\n"
  end

end