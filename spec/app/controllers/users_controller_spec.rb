require 'spec_helper'

module YugiohX2Spec
  module UsersControllerSpec
    RSpec.describe YugiohX2::AccountsController do
      describe "#get" do
        let(:get_response) { controller.get(request) }
        let(:controller) { YugiohX2::UsersController.new }
        let(:request) { double("Request", header: header, query: {}, remote_ip: '127.0.0.1') }
        let!(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: YugiohX2::User.encrypt_password('TestUser', 'TestPassword')) }

        context "user not logged in" do
          let(:header) { {} }

          it "returns 401" do
            json, response_code = get_response

            expect(response_code).to eq(401)
            expect(JSON.parse(json)).to eq({'message' => "You are not authorized to make this request"})
          end
        end

        context "user is logged in" do
          let(:header) { {'uuid' => [uuid]} }

          context "session expired" do
            let(:uuid) do
              _uuid = GlobalHelper.login('TestUser', 'TestPassword')
              YugiohX2::Session.find_by_uuid(_uuid).update_attribute(:expires_at, DateTime.parse('2016-01-01'))
              _uuid
            end

            it "returns 401" do
              json, response_code = get_response
              expect(response_code).to eq(401)
              expect(JSON.parse(json)).to eq({'message' => "You are not authorized to make this request"})
            end
          end

          context "session active" do
            let(:uuid) do
              GlobalHelper.login('TestUser', 'TestPassword')
            end

            it "returns the readable user fields" do
              json, response_code = get_response
              expect(response_code).to eq(200)
              expect(JSON.parse(json)).to eq({'username' => "TestUser", 'dp' => 0})
            end
          end
        end
      end
    end
  end
end
