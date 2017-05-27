require 'spec_helper'

module YugiohX2Spec
  module AccountsControllerSpec
    module Helper
      class << self
        include RSpec::Mocks::ExampleMethods

        def login(username, password)
          accounts_controller = YugiohX2::AccountsController.new
          mock_request = double("Request", query: {'username' => username, 'password' => password}, remote_ip: '127.0.0.1')
          json, response_code = accounts_controller.login(mock_request)

          if response_code == 200
            JSON.parse(json)['uuid']
          else
            raise "An error occurred logging in"
          end
        end
      end
    end

    RSpec.describe YugiohX2::AccountsController do
      describe "#find" do
        let(:controller) { YugiohX2::UsersController.new }
        let(:request) { double("Request", query: query, remote_ip: '127.0.0.1') }
        let!(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: YugiohX2::User.encrypt_password('TestUser', 'TestPassword')) }

        context "invalid parameters" do
          let(:query) { {'unknown_key' => 'unknown_value'} }

          it "returns 422" do
            json, response_code = controller.find(request)
            expect(response_code).to eq(422)
            expect(JSON.parse(json)).to eq({'message' => "invalid request parameters"})
          end
        end

        context "user not logged in" do
          let(:query) { {'uuid' => 'invalid_uuid'} }

          it "returns 401" do
            json, response_code = controller.find(request)

            expect(response_code).to eq(401)
            expect(JSON.parse(json)).to eq({'message' => "You are not authorized to make this request"})
          end
        end

        context "user is logged in" do
          let(:query) { {'uuid' => uuid} }

          context "session expired" do
            let(:uuid) do
              _uuid = Helper.login('TestUser', 'TestPassword')
              YugiohX2::Session.find_by_uuid(_uuid).update_attribute(:expires_at, DateTime.parse('2016-01-01'))
              _uuid
            end

            it "returns the readable user fields" do
              json, response_code = controller.find(request)
              expect(response_code).to eq(401)
              expect(JSON.parse(json)).to eq({'message' => "You are not authorized to make this request"})
            end
          end

          context "session active" do
            let(:uuid) do
              Helper.login('TestUser', 'TestPassword')
            end

            it "returns the readable user fields" do
              json, response_code = controller.find(request)
              expect(response_code).to eq(200)
              expect(JSON.parse(json)).to eq({'username' => "TestUser", 'dp' => 0})
            end
          end
        end
      end
    end
  end
end