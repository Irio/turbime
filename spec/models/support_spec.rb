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

  describe "#confirmed" do
    let(:project) { Project.make! goal: 1000 }
    let(:project_2) { Project.make! goal: 1200 }
    before do
      10.times { |i| Support.make!(project: project, amount: 100).confirm! }
      3.times { |i| Support.make!(project: project_2, amount: 100) }
    end

    it "should return corect confirmed support" do
      Support.confirmed.should have(10).items
    end
  end
end
