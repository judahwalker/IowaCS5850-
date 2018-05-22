require 'request_spec_helper'

describe 'sink endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of sink' do
        get '/sink', {}, HTTP_ACCEPT: 'application/vnd.sink+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/sink.json', {}, HTTP_ACCEPT: 'application/vnd.sink+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of sink under a root node' do
        get '/sink', {}, HTTP_ACCEPT: 'application/vnd.sink+json; version=2'

        json = JSON.parse(response.body)
        sink = json.fetch('sink')

        # these values are hard-coded in the controller as example
        expect(sink.count).to eq(1)
        expect(sink.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/sink.json', {}, HTTP_ACCEPT: 'application/vnd.sink+json; version=2'

        json = JSON.parse(response.body)
        sink = json.fetch('sink')

        expect(sink.count).to eq(1)
        expect(sink.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
