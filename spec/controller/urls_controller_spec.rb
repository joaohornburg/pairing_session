require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:test_url) { 'https://myhost.com/path' }

  describe 'POST create' do
    context 'with valid params' do
      let(:params) { { url: test_url } }
      let(:my_shortened_url) { 'ac' }

      before do
        allow(UrlShortener).to receive(:call).and_return(my_shortened_url)
      end

      it 'is successfull' do
        post :create, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns the shortenend url' do
        post :create, params: params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['shortened_url']).to eq my_shortened_url
      end

      context 'url already exists' do
        before do
          Url.create(url: test_url)
        end

        it 'does not create a new one' do
          expect do
            post :create, params: params
          end.not_to change { Url.count }
        end

        it 'returns the existing one' do
          post :create, params: params
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['shortened_url']).to eq my_shortened_url
        end
      end
    end

    describe 'GET show' do      
      context 'with valid params' do
        context 'when url exists' do
          let(:url) { Url.create(url: test_url) }
          let(:shortend_url) { UrlShortener.call(url.id) }
          let(:params) { { shortened: shortend_url } }

          before do
            allow(UrlUnshortener).to receive(:call).and_return(url.id)
          end
          
          it 'is successfull' do
            get :show, params: params
            expect(response).to have_http_status(:ok)
          end
          
          it 'returns the unshortened url' do
            get :show, params: params
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['url']).to eq test_url
          end

          it 'increments the url hit count' do
            expect do
              get :show, params: params
            end.to change { Url.find_by(url: test_url).hits }.by(1) 
          end
        end

        context 'url does not exist' do
          let(:params) { { shortened: 'whatever' } }

          it 'heads 404' do
            get :show, params: params
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end

    describe 'GET index' do
      context 'with valid params' do
        let!(:url_1) { Url.create(url: test_url, hits: 20) }
        let(:test_url_2) { 'https://anotherurl.com' }
        let!(:url_2) { Url.create(url: test_url_2, hits: 5) }

        before do
          100.times do
            Url.create!(url: "http://www.#{Time.now}#{Random.rand}.com")
          end
        end

        it 'returns a list of urls, ordered by hits, limited to 100' do
          get :index
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[0]).to eq({ 'url' => test_url, 'hit_count' =>  url_1.hits})
          expect(parsed_response[1]).to eq({ 'url' => test_url_2, 'hit_count' =>  url_2.hits})
          expect(parsed_response.count).to eq 100
        end
      end
    end
  end
end
