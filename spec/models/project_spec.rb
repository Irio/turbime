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
  end

  describe "associations" do
    it { should belong_to :user }
  end
end
