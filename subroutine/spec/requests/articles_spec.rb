require 'request_spec_helper'

describe 'subroutine endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of subroutine' do
        get '/subroutine', {}, HTTP_ACCEPT: 'application/vnd.subroutine+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/subroutine.json', {}, HTTP_ACCEPT: 'application/vnd.subroutine+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of subroutine under a root node' do
        get '/subroutine', {}, HTTP_ACCEPT: 'application/vnd.subroutine+json; version=2'

        json = JSON.parse(response.body)
        subroutine = json.fetch('subroutine')

        # these values are hard-coded in the controller as example
        expect(subroutine.count).to eq(1)
        expect(subroutine.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/subroutine.json', {}, HTTP_ACCEPT: 'application/vnd.subroutine+json; version=2'

        json = JSON.parse(response.body)
        subroutine = json.fetch('subroutine')

        expect(subroutine.count).to eq(1)
        expect(subroutine.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
