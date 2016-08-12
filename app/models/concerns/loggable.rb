module Loggable
  extend ActiveSupport::Concern

  included do
    has_many :activity_logs, as: :loggeable
    accepts_nested_attributes_for :activity_logs
  end
end
