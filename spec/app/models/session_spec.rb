require 'spec_helper'

module YugiohX2Spec
  module SessionSpec
    RSpec.describe YugiohX2::Session do
      describe 'validations' do
        context 'user_id' do
          it "should be present" do
            session = YugiohX2::Session.new(user_id: nil)
            session.valid?
            expect(session.errors[:user_id]).to include("can't be blank")
          end
        end
      end

      describe "associations" do
        let(:user) { YugiohX2::User.create(username: "TestUser", encrypted_password: "{SHA256}some_encrypted_password") }

        it "has one session" do
          session = YugiohX2::Session.create(user_id: user.id)
          expect(session.user).to eq(user)
        end
      end

      describe "create" do
        let(:encrypted_password) { "{SHA256}#{Digest::SHA256.digest("test_user:test_password")}" }

        it 'assigns a uuid' do
          session = YugiohX2::Session.create!(user_id: 1, remote_ip: '127.0.0.1', expires_at: DateTime.parse("2017-05-22 12:00:00"))
          expect(session.id.to_s).to match(/\d+/)
          uuid = session.uuid
          expect(uuid.length).to eq(36)

          session.expires_at = DateTime.parse("2017-05-22 13:00:00")
          session.save!
          session.reload
          expect(session.uuid).to eq(uuid)
        end
      end
    end
  end
end
