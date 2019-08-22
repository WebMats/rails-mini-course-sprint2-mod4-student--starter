require 'rails_helper'

RSpec.describe RewardsReport do
  describe "instance methods" do
    describe ".notify" do
      let(:rewards) { [
        double("Reward", purchase_count: 30),
        double("Reward", purchase_count: 70),
        double("Reward", purchase_count: 100)
      ] }
      it "should affirm notify called NotificationService using total_purchase" do
        allow(NotificationService).to receive(:send_purchase_report)

        RewardsReport.new(rewards).notify

        expect(NotificationService).to have_received(:send_purchase_report).with(200)
      end
    end
  end
end
