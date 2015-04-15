module CoreExtensions
  module String
    module Transcoding
      require 'charlock_holmes'

      def to_utf8
        detection = CharlockHolmes::EncodingDetector.detect(self)
        CharlockHolmes::Converter.convert(self, detection[:encoding], 'UTF-8')
      end
    end 
  end
end