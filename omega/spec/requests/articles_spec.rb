require 'request_spec_helper'

describe 'omega endpoint' do
  describe 'GET #index' do
    describe 'v1' do
      it 'responds with an array of omega' do
        get '/omega', {}, HTTP_ACCEPT: 'application/vnd.omega+json; version=1'

        json = JSON.parse(response.body)

        # these values are hard-coded in the controller as example
        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/omega.json', {}, HTTP_ACCEPT: 'application/vnd.omega+json; version=1'

        json = JSON.parse(response.body)

        expect(json.count).to eq(1)
        expect(json.first['name']).to eq('The Things')
      end
    end

    describe 'v2' do
      it 'responds with an array of omega under a root node' do
        get '/omega', {}, HTTP_ACCEPT: 'application/vnd.omega+json; version=2'

        json = JSON.parse(response.body)
        omega = json.fetch('omega')

        # these values are hard-coded in the controller as example
        expect(omega.count).to eq(1)
        expect(omega.first['name']).to eq('The Things')
      end

      it 'accepts requests with .json suffix' do
        get '/omega.json', {}, HTTP_ACCEPT: 'application/vnd.omega+json; version=2'

        json = JSON.parse(response.body)
        omega = json.fetch('omega')

        expect(omega.count).to eq(1)
        expect(omega.first['name']).to eq('The Things')
      end
    end
  end
end
Contact GitHub API Training Shop Blog About
