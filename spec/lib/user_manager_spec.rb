require 'spec_helper'

module YugiohX2Spec
  RSpec.describe YugiohX2Lib::UserManager do
    describe '#prompt_username' do
      let(:user_manager) { YugiohX2Lib::UserManager.new(is, os) }
      let(:is) { StringIO.new }
      let(:os) { StringIO.new }

      context 'more than 2 characters inputted' do
        before :each do
          allow(is).to receive(:gets).and_return("MyUsername\n")
        end

        it 'returns the username' do
          username = user_manager.prompt_username
          expect(username).to eq("MyUsername")
        end
      end

      context 'less than 2 characters inputted' do
        before :each do
          allow(is).to receive(:gets).and_return("M\n", "Y\n", "ValidUsername\n")
        end

        it 'reprompts until a valid username is inputted' do
          username = user_manager.prompt_username
          expect(username).to eq("ValidUsername")
        end
      end
    end
  end
end
