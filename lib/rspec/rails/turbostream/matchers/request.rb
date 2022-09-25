require 'nokogiri'
module RSpec
  module Rails
    module Matchers
      class Turbostream < RSpec::Rails::Matchers::BaseMatcher
        CONTENT_TYPE_HEADER = 'Content-Type'.freeze
        TURBO_STREAM_TAG = 'turbo-stream'.freeze

        attr_reader :action, :target, :response

        def initialize(scope, action = nil, target = nil)
          @scope = scope
          @action = action
          @target = target
          @assertions = []
          @response = scope.response

          match_turbostream
        end

        def match?
          @assertions.compact.all?
        end

        def match(expected, actual)
          match?
        end

        private

        def match_turbostream
          not_empty
          match_headers
          match_target
          match_action
        end

        def doc
          @doc ||= ::Nokogiri.HTML(@response.body)
        end

        def headers
          @response.headers
        end

        def not_empty
          @assertions << (!doc.css(TURBO_STREAM_TAG).empty?)
        end

        def match_headers
          @assertions << (headers[CONTENT_TYPE_HEADER].include?(RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME))
        end

        def match_target
          return if target.nil?

          @assertions << (!doc.css("#{TURBO_STREAM_TAG}[target='#{target}']").empty?)
        end

        def match_action
          return if action.nil?

          @assertions << (!doc.css("#{TURBO_STREAM_TAG}[action='#{action}']").empty?)
        end
      end

      # @api public
      # Passes if `response` has a matching tubostream tag.
      #
      # @example Accepts numeric and symbol statuses
      #   expect(response).to be_a_turbostream
      #   expect(response).to be_a_turbostream(:update)
      #   expect(response).to be_a_turbostream(:update, :search_results)
      #
      def be_a_turbostream(action = nil, target = nil)
        Turbostream.new(self, action, target)
      end
    end
  end
end
