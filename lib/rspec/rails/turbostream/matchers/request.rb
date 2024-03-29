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
          @messages = []
          @response = scope.response

          match_turbostream
        end

        def match?
          @assertions.compact.all?
        end

        def matches?(actual)
          @actual = actual
          match?
        end

        def match(expected, actual)
          @scope = expected
          matches?(actual)
        end

        def failure_message
          @messages.join(" and ")
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
          check = (!doc.css(TURBO_STREAM_TAG).empty?)
          @messages << 'Did not incude a turbostream tag' if !check
          @assertions << check
        end

        def match_headers
          check = (headers[CONTENT_TYPE_HEADER].include?(RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME))
          @messages << 'Does not contain turbostream header' if !check
          @assertions << check
        end

        def match_target
          return if target.nil?

          check = (!doc.css("#{TURBO_STREAM_TAG}[target='#{target}']").empty?)
          @messages << "Does not match target of #{target}" if !check
          @assertions << check
        end

        def match_action
          return if action.nil?

          check = (!doc.css("#{TURBO_STREAM_TAG}[action='#{action}']").empty?)
          @messages << "Does not match action of #{action}" if !check
          @assertions << check
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
