require 'request_spec_helper'

describe 'gamma endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of gamma' do
        get '/gamma', {}, HTTP_ACCEPT: 'application/vnd.gamma+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/gamma.json', {}, HTTP_ACCEPT: 'application/vnd.gamma+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of gamma under a root node' do
        get '/gamma', {}, HTTP_ACCEPT: 'application/vnd.gamma+json; version=2'

        json = JSON.parse(response.body)
        gamma = json.fetch('gamma')

        # these values are hard-coded in the controller as example
        expect(gamma.count).to eq(1)
        expect(gamma.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/gamma.json', {}, HTTP_ACCEPT: 'application/vnd.gamma+json; version=2'

        json = JSON.parse(response.body)
        gamma = json.fetch('gamma')

        expect(gamma.count).to eq(1)
        expect(gamma.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
