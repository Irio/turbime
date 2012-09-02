require 'spec_helper'

describe Support do
  describe "validations" do
    it{ should validate_presence_of :user }
    it{ should validate_presence_of :project }
    it{ should validate_presence_of :amount }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :project }
  end
end
