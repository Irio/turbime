require 'spec_helper'

describe Project do
  describe "validations" do
    it{ should validate_presence_of :name }
    it{ should validate_presence_of :headline }
    it{ should validate_presence_of :description }
    it{ should validate_presence_of :goal }
    it{ should validate_presence_of :video }

    describe "urls" do
      subject { Project.make! }
      let(:url_with_http) { "http://www.turbi.me/" }
      let(:url_without_http) { "www.turbi.me" }

      it "accepts urls with http" do
        subject.video = url_with_http
        subject.repository = url_with_http
        should have(0).error_on(:video)
        should have(0).error_on(:repository)
      end

      it "dont accepts urls without http" do
        subject.video = url_without_http
        subject.repository = url_without_http
        should have_at_least(1).error_on(:video)
        should have_at_least(1).error_on(:repository)
      end
    end

    describe "expires_at" do
      it "dont accepts dates in the past" do
        subject.expires_at = DateTime.current - 1.day
        subject.should have_at_least(1).error_on(:expires_at)
      end

      it "accepts dates in more than one week" do
        subject = Project.make
        subject.expires_at = DateTime.current + 1.5.weeks
        subject.should be_valid
      end
    end
  end

  describe "associations" do
    it { should belong_to :user }
  end

  describe "scopes" do
    describe "visible" do
      before do
        user = User.make!
        Project.make! visible: true, user: user
        Project.make! visible: true, user: user
        Project.make! visible: false, user: user
      end
      it "should return only visible projects" do
        Project.visible.should have(2).items
      end
    end

    describe "expired" do
      before do
        user = User.make!
        Project.make! expires_at: 1.month.from_now, user: user
        past_date = -1.month.from_now
        Delorean.time_travel_to("2 months ago") do
          Project.make! expires_at: past_date, user: user
        end
      end

      it "should return only expired projects" do
        Project.expired.should have(1).items
      end
    end
  end
end
