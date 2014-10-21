require 'rails_helper'
describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
        :card => {
            :number => '4242424242424242',
            :exp_month => 9,
            :exp_year => 2015,
            :cvc => "314"
        },
    ).id
  end
  let(:declined_card_token) do
    Stripe::Token.create(
        :card => {
            :number => '4000000000000002',
            :exp_month => 9,
            :exp_year => 2015,
            :cvc => "314"
        },
    ).id
  end
  describe StripeWrapper::Charge do

    #let(:customer) { StripeWrapper::Customer.create(email: 'test@test.com', card: token).id }


    context "with valid card" do

      let(:response) {  StripeWrapper::Charge.create(amount: 999, card: valid_token) }
      it "charges the card successfully", :vcr do
        expect(response).to be_succesful
      end
    end
    context "with invalid card" do

      let(:response) {  StripeWrapper::Charge.create(amount: 999, card: declined_card_token) }
      it "does not charge the card successfully", :vcr  do
        expect(response).to_not be_succesful
      end
      it "contains an error message", :vcr do
        expect(response.error_message).to eq 'Your card was declined.'
      end
    end
  end

  describe StripeWrapper::Customer do


    describe ".create" do
      context "valid card" do
        let(:response)  { StripeWrapper::Customer.create(email: Faker::Internet.email, card: valid_token) }

        it "creates a customer with a valid card", :vcr do
          expect(response).to be_succesful
        end

        it "contains a customer id", :vcr do
          expect(response.id).to_not be_nil
        end
      end
      context "declined card" do
        let(:response)  { StripeWrapper::Customer.create(email: Faker::Internet.email, card: declined_card_token) }
        it "does not create a customer with an invalid card", :vcr do
          expect(response).to_not be_succesful
        end
        it "contains an error message", :vcr do
          expect(response.error_message).to eq 'Your card was declined.'
        end
      end
    end
  end
end