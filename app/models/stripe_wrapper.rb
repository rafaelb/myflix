module StripeWrapper
  class Charge
    def initialize(response, status)
      @response = response
      @status = status
    end
    def self.create(options={})
      begin
        response = Stripe::Charge.create(amount: options[:amount], currency: 'usd', card: options[:card])
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def succesful?
      @status == :success
    end

    def error_message
      @response.message
    end
  end

  class Customer
    def initialize(response, status)
      @response = response
      @status = status
    end
    def self.create(options={})
      begin
        response = Stripe::Customer.create(
            card: options[:card],
            plan: "myflix",
            email: options[:email]
        )

        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def succesful?
      @status == :success
    end

    def error_message
      @response.message
    end

    def id
      @response.id
    end
  end
end