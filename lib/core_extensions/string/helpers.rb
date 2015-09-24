module CoreExtensions
  module String
    module Helpers

      def lchomp(sep = $/)
        self.start_with?(sep) ? self[sep.size..-1] : self
      end
    end
  end
end
