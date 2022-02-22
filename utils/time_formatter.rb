module TimeFormatter
  TIME_FORMAT = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }

  def self.time_by_format(query_attributes)
    TIME_FORMAT.keys.each do |key|
      query_attributes.gsub!(key.to_s, TIME_FORMAT[key])
    end
    query_attributes += "\n"

    Time.new.strftime(query_attributes)
  end
end