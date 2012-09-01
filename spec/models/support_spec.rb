require 'spec_helper'

describe Support do
  describe "validations" do
    it{ should validate_presence_of :user }
    it{ should validate_presence_of :project }
    it{ should validate_presence_of :payment_method }
    it{ should validate_presence_of :payment_token }
  end
end
