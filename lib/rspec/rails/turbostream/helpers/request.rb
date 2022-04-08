module RSpec
  module Rails
    module Turbostream
      module Helpers
        module Request
          TURBO_MIME = 'text/vnd.turbo-stream.html'.freeze

          def turbo_post(*args)
            post(*turbo_header(*args))
          end

          def turbo_get(*args)
            get(*turbo_header(*args))
          end

          def turbo_put(*args)
            put(*turbo_header(*args))
          end

          def turbo_delete(*args)
            delete(*turbo_header(*args))
          end

          private

          def turbo_header(*args)
            if args.last.is_a?(Hash)
              args.last[:headers] ||= {}
              args.last[:headers][:Accept] = TURBO_MIME
            else
              args << { headers: { Accept: TURBO_MIME } }
            end

            args
          end
        end
      end
    end
  end
end
