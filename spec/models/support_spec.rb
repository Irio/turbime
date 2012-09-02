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

  describe "#confirm!" do
    let(:support) { Support.make! confirmed: false }
    it "should set true in confirm field" do
      support.confirm!
      support.reload
      support.confirmed.should == true
    end
  end
end
