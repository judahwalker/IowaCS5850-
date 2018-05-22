require 'request_spec_helper'

describe 'gate endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of gate' do
        get '/gate', {}, HTTP_ACCEPT: 'application/vnd.gate+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/gate.json', {}, HTTP_ACCEPT: 'application/vnd.gate+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of gate under a root node' do
        get '/gate', {}, HTTP_ACCEPT: 'application/vnd.gate+json; version=2'

        json = JSON.parse(response.body)
        gate = json.fetch('gate')

        # these values are hard-coded in the controller as example
        expect(gate.count).to eq(1)
        expect(gate.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/gate.json', {}, HTTP_ACCEPT: 'application/vnd.gate+json; version=2'

        json = JSON.parse(response.body)
        gate = json.fetch('gate')

        expect(gate.count).to eq(1)
        expect(gate.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
