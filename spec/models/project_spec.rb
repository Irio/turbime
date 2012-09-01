require 'spec_helper'

describe Project do
  describe "validations" do
    it{ should validate_presence_of :user }
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
        should have(0).error_on(:repository)
      end

      it "dont accepts urls without http" do
        subject.video = url_without_http
        subject.repository = url_without_http
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
    it { should have_many :supports }
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

  describe "auto_html ()" do
    text = "A _simple_ description of *project* http://turbi.me"
    let(:project) { Project.make!(:description => text) }

    it "should have the right description" do
      project.description.should == "A _simple_ description of *project* http://turbi.me"
    end

    it "should have the right description_html" do
      project.description_html.should == "<p><p>A <em>simple</em> description of <em>project</em> <a href=\"http://turbi.me\" target=\"_blank\">http://turbi.me</a></p>\n</p>"
    end
  end

  describe "#video" do
    let(:user) { User.make! }
    let(:project) { Project.make! user: user, video: "http://vimeo.com/28220980" }

    describe "vimeo" do
      subject{ project }

      its(:vimeo) do
        subject.id.should == "28220980"
        subject.embed_url.should == "http://player.vimeo.com/video/28220980"
      end

      it "should get vimeo image URL and store it" do
        Project.any_instance.unstub(:store_image_url)
        new_project = Project.make! user: user, video: "http://vimeo.com/28220980"
        new_project.image.should == 'http://b.vimeocdn.com/ts/188/251/188251185_640.jpg'
      end
    end
  end


  describe "#cannot_edit?" do
    let(:persisted) { Project.make! }

    it "allows edit any attribute when unpersisted" do
      subject.cannot_edit?(:name).should be_false
      subject.cannot_edit?(:description).should be_false
      subject.cannot_edit?(:expires_at).should be_false
      subject.cannot_edit?(:headline).should be_false
      subject.cannot_edit?(:video).should be_false
      subject.cannot_edit?(:repository).should be_false
      subject.cannot_edit?(:code_funded).should be_false
      subject.cannot_edit?(:goal).should be_false
    end

    it "cannot edit name when persisted" do
      persisted.cannot_edit?(:name).should be_true
    end

    it "cannot edit description when persisted" do
      persisted.cannot_edit?(:description).should be_true
    end

    it "cannot edit expires_at when persisted" do
      persisted.cannot_edit?(:expires_at).should be_true
    end

    it "cannot edit headline when persisted" do
      persisted.cannot_edit?(:headline).should be_true
    end

    it "cannot edit video when persisted" do
      persisted.cannot_edit?(:video).should be_true
    end

    it "cannot edit repository when persisted" do
      persisted.cannot_edit?(:repository).should be_true
    end

    it "can edit code_funded when persisted" do
      persisted.cannot_edit?(:code_funded).should be_false
    end

    it "cannot edit goal when persisted" do
      persisted.cannot_edit?(:goal).should be_true
    end
  end
end
