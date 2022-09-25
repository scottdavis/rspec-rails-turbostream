module RSpec
  module Rails
    module Turbostream
      module Helpers
        module Request
          TURBO_MIME = 'text/vnd.turbo-stream.html'.freeze

          def turbo_post(location, args)
            new_args = turbo_header(args)
            post(location, **new_args)
          end

          def turbo_get(location, args)
            new_args = turbo_header(args)
            get(location, **new_args)
          end

          def turbo_put(location, args)
            new_args = turbo_header(args)
            put(location, **new_args)
          end

          def turbo_delete(location, args)
            new_args = turbo_header(args)
            delete(location, **new_args)
          end

          private

          def turbo_header(args = {})
            puts args.inspect
            args[:headers] ||= {}
            args[:headers][:Accept] = TURBO_MIME

            args
          end
        end
      end
    end
  end
end
