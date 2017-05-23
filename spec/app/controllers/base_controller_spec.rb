require 'spec_helper'

module YugiohX2Spec
  module BaseControllerSpec
    RSpec.describe YugiohX2::BaseController do
      describe "#login" do
        let(:controller) { YugiohX2::BaseController.new }
        let(:request) { double("Request", query: query, remote_ip: '127.0.0.1') }

        context "invalid parameters" do
          let(:query) { {'username' => 'TestUser', 'unknown_key' => 'unknown_value'} }

          it "returns 422" do
            json, response_code = controller.login(request)

            expect(response_code).to eq(422)
            expect(JSON.parse(json)).to eq({'message' => "invalid request parameters"})
          end
        end

        context "user does not exist" do
          let(:query) { {'username' => 'TestUser', 'password' => 'TestPassword'} }

          it "returns 401" do
            json, response_code = controller.login(request)

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
            let(:query) { {'username' => 'TestUser', 'password' => 'TestPassword'} }

            context "session has expired" do
              let(:expires_at) { DateTime.now.advance(hours: -1) }

              it "returns 200" do
                json, response_code = controller.login(request)

                expect(response_code).to eq(200)
                expect(JSON.parse(json)).to eq({'message' => "You are already logged in"})
              end
            end

            context "session has not expired" do
              let(:expires_at) { DateTime.parse('2100-01-01') }

              it "returns 200" do
                json, response_code = controller.login(request)

                expect(response_code).to eq(200)
                expect(JSON.parse(json)).to eq({'message' => "You are already logged in"})
              end
            end
          end

          context "user password is incorrect" do
            let(:query) { {'username' => 'TestUser', 'password' => 'WrongPassword'} }

            it "returns 401" do
              json, response_code = controller.login(request)

              expect(response_code).to eq(401)
              expect(JSON.parse(json)).to eq({'message' => "invalid username and password"})
            end
          end

          context "user password is correct" do
            let(:query) { {'username' => 'TestUser', 'password' => 'TestPassword'} }

            it "returns 200" do
              json, response_code = controller.login(request)

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
        let(:controller) { YugiohX2::BaseController.new }
        let(:request) { double("Request", query: query, remote_ip: '127.0.0.1') }

        context "invalid parameters" do
          let(:query) { {} }

          it "returns 422" do
            json, response_code = controller.logout(request)

            expect(response_code).to eq(422)
            expect(JSON.parse(json)).to eq({'message' => "invalid request parameters"})
          end
        end

        context "session does not exist" do
          let(:query) { {'uuid' => 'c26c81f8-f330-467a-99b3-25389ebb4ef4'} }

          it "returns 404" do
            json, response_code = controller.logout(request)

            expect(response_code).to eq(404)
            expect(JSON.parse(json)).to eq({'message' => "No sessions found for uuid"})
          end
        end

        context "session exists" do
          let!(:user) do
            YugiohX2::Session.create!(user_id: 1, uuid: uuid, remote_ip: remote_ip)
          end
          let(:query) { {'uuid' => uuid} }
          let(:uuid) { 'c26c81f8-f330-467a-99b3-25389ebb4ef4' }

          context 'correct remote_ip' do
            let(:remote_ip) { '127.0.0.1' }

            it "returns 200 and removes the session record" do
              json, response_code = controller.logout(request)

              expect(response_code).to eq(200)
              expect(JSON.parse(json)).to eq({'message' => "You have been logged out"})
              expect(YugiohX2::Session.count).to eq(0)
            end
          end

          context 'incorrect remote_ip' do
            let(:remote_ip) { '192.168.20.25' }

            it "returns 404" do
              json, response_code = controller.logout(request)

              expect(response_code).to eq(404)
              expect(JSON.parse(json)).to eq({'message' => "No sessions found for uuid"})
            end
          end
        end
      end
    end
  end
end
