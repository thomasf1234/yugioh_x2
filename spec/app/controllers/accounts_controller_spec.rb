require 'spec_helper'

module YugiohX2Spec
  module AccountsControllerSpec
    RSpec.describe YugiohX2::AccountsController do
      describe "#login" do
        let(:get_response) { controller.login(request) }
        let(:controller) { YugiohX2::AccountsController.new }
        let(:request) { double("Request",
                               content_type: 'application/json',
                               header: {},
                               body: body,
                               remote_ip: '127.0.0.1') }

        context "invalid parameters" do
          let(:body) { {'username' => 'TestUser', 'unknown_key' => 'unknown_value'}.to_json }

          it "returns 422" do
            json, response_code = get_response

            expect(response_code).to eq(422)
            expect(JSON.parse(json)).to eq({'message' => "invalid request parameters"})
          end
        end

        context "user does not exist" do
          let(:body) { {'username' => 'TestUser', 'password' => 'TestPassword'}.to_json }

          it "returns 401" do
            json, response_code = get_response

            expect(response_code).to eq(401)
            expect(JSON.parse(json)).to eq({'message' => "invalid username and password"})
          end
        end

        context "user exists" do
          let!(:user) do
            YugiohX2::User.create!(username: 'TestUser',
                                   encrypted_password: YugiohX2::User.encrypt_password('TestUser', 'TestPassword'))
          end

          context "user already logged in" do
            let!(:session) do
              YugiohX2::Session.create!(user_id: user.id, remote_ip: '127.0.0.1',  expires_at: expires_at)
            end
            let(:body) { {'username' => 'TestUser', 'password' => 'TestPassword'}.to_json }

            context "session has expired" do
              let(:expires_at) { DateTime.now.advance(hours: -1) }

              it "returns 200" do
                json, response_code = get_response

                expect(response_code).to eq(200)
                response_body = JSON.parse(json)
                expect(response_body['message']).to eq("Welcome back #{user.username}.")
                expect(response_body['uuid'].length).to eq(36)
                expect(YugiohX2::Session.count).to eq(1)
                expect(user.session).to eq(YugiohX2::Session.first)
                expect(user.session.uuid).to eq(response_body['uuid'])
                expect(user.session.remote_ip).to eq('127.0.0.1')
              end
            end

            context "session has not expired" do
              let(:expires_at) { DateTime.parse('2100-01-01') }

              it "returns 200" do
                json, response_code = get_response

                expect(response_code).to eq(200)
                response_body = JSON.parse(json)
                expect(response_body['message']).to eq("Welcome back #{user.username}.")
                expect(response_body['uuid'].length).to eq(36)
                expect(YugiohX2::Session.count).to eq(1)
                expect(user.session).to eq(YugiohX2::Session.first)
                expect(user.session.uuid).to eq(response_body['uuid'])
                expect(user.session.remote_ip).to eq('127.0.0.1')
              end
            end
          end

          context "user password is incorrect" do
            let(:body) { {'username' => 'TestUser', 'password' => 'WrongPassword'}.to_json }

            it "returns 401" do
              json, response_code = get_response

              expect(response_code).to eq(401)
              expect(JSON.parse(json)).to eq({'message' => "invalid username and password"})
            end
          end

          context "user password is correct" do
            let(:body) { {'username' => 'TestUser', 'password' => 'TestPassword'}.to_json }

            it "returns 200" do
              json, response_code = get_response

              expect(response_code).to eq(200)
              response_body = JSON.parse(json)
              expect(response_body['message']).to eq("Welcome back #{user.username}.")
              expect(response_body['uuid'].length).to eq(36)
              expect(YugiohX2::Session.count).to eq(1)
              expect(user.session).to eq(YugiohX2::Session.first)
              expect(user.session.uuid).to eq(response_body['uuid'])
              expect(user.session.remote_ip).to eq('127.0.0.1')
            end
          end
        end
      end

      describe "#logout" do
        let(:get_response) { controller.logout(request) }
        let(:controller) { YugiohX2::AccountsController.new }
        let(:request) { double("Request",
                               header: header,
                               body: {},
                               remote_ip: '127.0.0.1') }

        context "session does not exist" do
          let(:header) { {'uuid' => ['c26c81f8-f330-467a-99b3-25389ebb4ef4']} }

          it "returns 404" do
            json, response_code = get_response

            expect(response_code).to eq(404)
            expect(JSON.parse(json)).to eq({'message' => "No sessions found for uuid"})
          end
        end

        context "session exists" do
          let!(:user) do
            YugiohX2::Session.create!(user_id: 1, uuid: uuid, remote_ip: remote_ip)
          end
          let(:header) { {'uuid' => [uuid]} }
          let(:uuid) { 'c26c81f8-f330-467a-99b3-25389ebb4ef4' }

          context 'correct remote_ip' do
            let(:remote_ip) { '127.0.0.1' }

            it "returns 200 and removes the session record" do
              json, response_code = get_response

              expect(response_code).to eq(200)
              expect(JSON.parse(json)).to eq({'message' => "You have been logged out"})
              expect(YugiohX2::Session.count).to eq(0)
            end
          end

          context 'incorrect remote_ip' do
            let(:remote_ip) { '192.168.20.25' }

            it "returns 404" do
              json, response_code = get_response

              expect(response_code).to eq(404)
              expect(JSON.parse(json)).to eq({'message' => "No sessions found for uuid"})
            end
          end
        end
      end
    end
  end
end
