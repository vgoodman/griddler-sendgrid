module Griddler
  module Sendgrid
    class Adapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        params.merge(
          to: recipients(:to),
          cc: recipients(:cc),
          attachments: attachment_files,
        )
      end

      private

      attr_reader :params

      def recipients(key)
        raw = ( params[key] || '' )
        if raw.index(">")
          raw.split(">,").map do |addr|
            addr.strip!
            addr << ">" unless addr.index(">")
            addr
          end
        else
          raw.split(',')
        end
      end

      def attachment_files
        params.delete('attachment-info')
        attachment_count = params[:attachments].to_i

        attachment_count.times.map do |index|
          params.delete("attachment#{index + 1}".to_sym)
        end
      end
    end
  end
end
