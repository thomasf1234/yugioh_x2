require 'spec_helper'

module ServerSpec
  RSpec.describe Server do
    let(:client1) { Client.new("localhost", 3000) }
    let(:client2) { Client.new("localhost", 3000) }
    let(:client3) { Client.new("localhost", 3000) }

    context "connection attempt at maximum connections" do
      before :each do
        @server = Server.new
      end

      it "raise MaxConnectionsReached" do
        threads =[]

        begin
          threads << Thread.new { client1.connect }
          threads << Thread.new { client2.connect }

          begin
            client3.connect("localhost", 3000)
            fail("Should have thrown MaxConnectionsReached")
          rescue MaxConnectionsReached
          end
        ensure
          threads.each(&:join)
        end
      end
    end
  end
end