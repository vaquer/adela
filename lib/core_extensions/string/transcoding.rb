module CoreExtensions
  module String
    module Transcoding
      require 'charlock_holmes'

      def to_utf8
        detector = encoding_detector
        CharlockHolmes::Converter.convert(self, detector[:encoding], 'UTF-8')
      end

      private
      def encoding_detector
        detector = CharlockHolmes::EncodingDetector.detect(self)
        raise Exceptions::UnknownEncodingError unless detector
        detector
      end
    end
  end
end
