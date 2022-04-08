class FakeRequestHelperClass
  include RSpec::Rails::Turbostream::Helpers::Request
end


RSpec.describe RSpec::Rails::Turbostream::Helpers::Request do
  subject { FakeRequestHelperClass.new }

  context(:turbo_header) do
    it 'should set headers with no args' do
      args = subject.send(:turbo_header)
      expect(args).to eq(
        [
          {
            headers: {
              Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME
            }
          }
        ]
      )
    end

    it 'should set headers when headers are passed' do
      args = subject.send(:turbo_header, { headers: { 'Content-Type' => 'text' } })
      expect(args).to eq(
        [
          {
            headers: {
              Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME,
              'Content-Type' => 'text'
            }
          }
        ]
      )
    end

    it 'should passed through args' do
      args = subject.send(:turbo_header, '/foo', { headers: { 'Content-Type' => 'text' } })
      expect(args).to eq(
        [
          '/foo',
          {
            headers: {
              Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME,
              'Content-Type' => 'text'
            }
          }
        ]
      )
    end
  end

  %i[get post put delete].each do |action|
    it "should call rails test helper \"#{action}\" with turbo_headers" do
      headers = {
            headers: {
              Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME,
            }
          }
      expect(subject).to receive(action).with(headers).once
      subject.send(:"turbo_#{action}")
    end
  end
end
