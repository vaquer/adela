module ActiveSupport
  class TimeWithZone
    def as_json(options = {})
      iso8601
    end
  end
end
