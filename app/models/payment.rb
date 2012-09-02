class Payment
  attr_reader :token, :redirect_uri
  attr_accessor :amount

  DESCRIPTION = {
    item: "Support on feature",
    payment: "Turbi.me"
  }

  def initialize(amount, custom_logger = nil)
    @amount = amount
    @logger = custom_logger || Rails.logger
  end

  def setup!(return_url, cancel_url, pay_client = nil)
    pay_client ||= client
    response = pay_client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: true
    )
    @token = response.token
    @logger.debug "Payment#setup! from #{pay_client.inspect}."
    @redirect_uri = response.redirect_uri
    self
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  def payment_request
    item = {
      name: DESCRIPTION[:item],
      description: DESCRIPTION[:item],
      amount: amount,
      category: :Digital
    }

    request_attrs = {
      amount: amount,
      description: DESCRIPTION[:payment],
      items: [item]
    }

    Paypal::Payment::Request.new request_attrs
  end


end
