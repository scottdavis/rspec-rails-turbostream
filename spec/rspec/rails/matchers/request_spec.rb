RSpec.describe RSpec::Rails::Turbostream::Matchers::Request do
  subject { RSpec::Rails::Turbostream::Matchers::Request::Base.new(scope, action, target) }
  let(:scope) do
    mocked_scope = double
    allow(mocked_scope).to receive(:response).and_return(response)

    mocked_scope
  end

  let(:response) do
    mocked_response = double

    allow(mocked_response).to receive(:body).and_return(body)
    allow(mocked_response).to receive(:headers).and_return(headers)

    mocked_response
  end
  
  let(:headers) { { 'Content-Type' => RSpec::Rails::Turbostream::Helpers::Request::TURBO_MIME } }

  describe 'matches response with just a turbo-stream tag' do
    let(:body) { '<turbo-stream></turbostream>' }
    let(:action) { nil }
    let(:target) { nil }

    it 'should be true' do
      expect(subject.match?).to be(true)
    end
  end

  describe 'matches response with a turbo-stream[action] tag' do
    let(:body) { '<turbo-stream action="search"></turbostream>' }
    let(:action) { :search }
    let(:target) { nil }

    it 'should be true' do
      expect(subject.match?).to be(true)
    end

    context "non matching action" do
      let(:action) { :somethingelse }
      it 'should not match' do
        expect(subject.match?).to be(false)
      end
    end
  end

  describe 'matches response with a turbo-stream[action][target] tag' do
    let(:body) { '<turbo-stream action="search" target="something"></turbostream>' }
    let(:action) { :search }
    let(:target) { :something }

    it 'should match' do
      expect(subject.match?).to be(true)
    end

    context 'non matching xml' do
      let(:body) { '<turbo-stream action="search" target="foobar"></turbostream>' }

      it 'it should not match if its the wrong target' do
        expect(subject.match?).to be(false)
      end
    end

    context 'non matching target' do
      let(:target) { :foo }

      it 'it should not match if its the wrong target' do
        expect(subject.match?).to be(false)
      end
    end

    context 'non matching target and action' do
      let(:action) { :bar }
      let(:target) { :foo }

      it 'it should not match if its the wrong target' do
        expect(subject.match?).to be(false)
      end
    end
  end
end
