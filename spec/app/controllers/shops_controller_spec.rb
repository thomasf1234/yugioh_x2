require 'spec_helper'

module YugiohX2Spec
  module ShopsControllerSpec
    RSpec.describe YugiohX2::ShopsController do
      describe "#password_machine" do
        let(:get_response) { controller.password_machine(request) }
        let(:controller) { YugiohX2::ShopsController.new }
        let(:request) { double("Request", header: header, content_type: 'application/json', body: body, remote_ip: '127.0.0.1') }
        let!(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: YugiohX2::User.encrypt_password('TestUser', 'TestPassword')) }

        context "user not logged in" do
          let(:header) { {} }
          let(:body) { {'serial_number' => '89631139'}.to_json }

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
            let(:body) { {'unknown_key' => 'unknown_value'}.to_json }

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

            context "invalid parameters" do
              let(:body) { {'unknown_key' => 'unknown_value'}.to_json }

              it "returns 422" do
                json, response_code = get_response
                expect(response_code).to eq(422)
                expect(JSON.parse(json)).to eq({'message' => "invalid request parameters"})
              end
            end

            context "valid parameters" do
              let(:body) { {'serial_number' => '46986414'}.to_json }

              context "user has less than 1000 dp" do
                it "returns 402 PaymentRequired" do
                  json, response_code = get_response

                  expect(response_code).to eq(402)
                  expect(JSON.parse(json)).to eq({'message' => "User does not have enough dp to fulfill the request"})
                end
              end

              context "user has at least 1000dp" do
                before :each do
                  FactoryGirl.create(:normal_card)
                  user.update_attribute(:dp, 1000)
                end

                context "the serial_number is not valid" do
                  let(:body) { {'serial_number' => '46986415'}.to_json }

                  it "returns 422" do
                    json, response_code = get_response

                    expect(response_code).to eq(422)
                    expect(JSON.parse(json)).to eq({'message' => "No card found for serial_number"})
                  end
                end

                context "the serial number is valid" do
                  context "user does not own a copy of the card" do
                    it "returns 403" do
                      json, response_code = get_response

                      expect(response_code).to eq(403)
                      expect(JSON.parse(json)).to eq({'message' => "User does not already possess a copy"})
                    end
                  end

                  context "user owns a copy of the card" do
                    it "takes 1000dp from the user and increments the user_card count" do
                      card = YugiohX2::Card.find_by_serial_number('46986414')
                      YugiohX2::UserCard.create!(user_id: user.id, card_id: card.id)

                      json, response_code = get_response

                      expect(response_code).to eq(200)
                      expect(JSON.parse(json)).to eq({'message' => "User has purchased Dark Magician for 1000dp",
                                                      'card_id' => card.id})

                      expect(user.reload.dp).to eq(0)
                      user_card = user.user_cards.find_by_card_id(card.id)
                      expect(user_card.count).to eq(2)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
