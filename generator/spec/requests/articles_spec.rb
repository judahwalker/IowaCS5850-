require 'request_spec_helper'

describe 'generator endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of generator' do
        get '/generator', {}, HTTP_ACCEPT: 'application/vnd.generator+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/generator.json', {}, HTTP_ACCEPT: 'application/vnd.generator+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of generator under a root node' do
        get '/generator', {}, HTTP_ACCEPT: 'application/vnd.generator+json; version=2'

        json = JSON.parse(response.body)
        generator = json.fetch('generator')

        # these values are hard-coded in the controller as example
        expect(generator.count).to eq(1)
        expect(generator.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/generator.json', {}, HTTP_ACCEPT: 'application/vnd.generator+json; version=2'

        json = JSON.parse(response.body)
        generator = json.fetch('generator')

        expect(generator.count).to eq(1)
        expect(generator.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
