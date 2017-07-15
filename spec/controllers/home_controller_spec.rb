require 'rails_helper'


RSpec.describe HomeController, type: :controller do

  before(:each) do
    $redis.flushall
  end

  describe "GET #index" do
    context 'when hitting under the rate limit' do
      it "returns 200" do
        100.times do
          get :index
          expect(response.status).to eq 200
        end
      end
    end

    context 'when going over the rate limit' do
      it "returns 429" do
        101.times { get :index }
        expect(response.status).to eq 429
      end

      it "returns 200 once the ip key expires" do
        101.times { get :index }
        $redis.expire request.remote_ip, 0
        get :index
        expect(response.status).to eq 200
      end
    end
  end
end
