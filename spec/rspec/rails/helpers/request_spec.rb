class FakeRequestHelperClass
  include RSpec::Rails::Turbostream::Helpers::Request
end


RSpec.describe RSpec::Rails::Turbostream::Helpers::Request do
  subject { FakeRequestHelperClass.new }

  context(:turbo_header) do
    it 'should set headers with no args' do
      args = subject.send(:turbo_header)
      expect(args).to eq(
        {
          headers: {
            Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME
          }
        }
      )
    end

    it 'should set headers when headers are passed' do
      args = subject.send(:turbo_header, { headers: { 'Content-Type' => 'text' } })
      expect(args).to eq(
        {
          headers: {
            Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME,
            'Content-Type' => 'text'
          }
        }
      )
    end

    it 'should passed through args' do
      args = subject.send(:turbo_header, { headers: { 'Content-Type' => 'text' } })
      expect(args).to eq(
        {
          headers: {
            Accept: RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME,
            'Content-Type' => 'text'
          }
        }
      )
    end
  end

  %i[get post put delete].each do |action|
    it "should call rails test helper \"#{action}\" with turbo_headers" do
      args = {
        params: {foo: 'bar'}
      }
      expect(subject).to receive(action).with('/somelocation', subject.send(:turbo_header, args)).once
      subject.send(:"turbo_#{action}", '/somelocation', args)
    end
  end
end
