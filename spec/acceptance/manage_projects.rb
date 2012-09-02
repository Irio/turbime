require "spec_helper"

feature "Managing projects" do
  scenario "Dont requires authentication at home" do
    visit "/"
    page.should_not have_content("Sign in with Facebook")
  end

  scenario "Dont allow guests create new projects" do
    visit "/"
    click_on "Start"
    page.should have_content("Sign in")
  end

  scenario "Allow signed user create projects" do
    auth_user
    click_on "Start"
    fill_in "Name", with: "Juquinha da Rocha"
    fill_in "Description", with: <<-EOF
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor.
    EOF
    fill_in "Headline", with: "Lorem ipsum dolor sit amet"
    fill_in "Video", with: "http://vimeo.com/43439161"
    fill_in "Repository", with: "https://github.com/Irio/mymoip"
    fill_in "Code funded", with: "https://github.com/Irio/mymoip/tree/v0.1.0"
    fill_in "Goal", with: "10.00"
    select_date (Date.current + 2.weeks), from: "project_expires_at"
    click_on "Create project"

    page.should have_content("Your project will be approved by our team.")
  end

  scenario "Project's owner can edit it's project" do
    user = auth_user
    subject = Project.make!(user: user)
    visit "/"
    click_on subject.name
    click_on "Edit"
    page.should_not have_content("You are not authorized to access this page.")
  end

  scenario "Users other than project's owner cannot edit a project" do
    subject = Project.make!
    user = auth_user
    visit "/"
    click_on subject.name
    page.should_not have_content("Edit")

    visit edit_project_path(subject)
    page.should have_content("You are not authorized to access this page.")
  end

  scenario "Guests cannot edit projects" do
    subject = Project.make!
    visit edit_project_path(subject)
    page.should have_content("Sign in")

    # TODO: Rescue CanCan expections
  end

  scenario "Index must not show invisible projects" do
    Project.make! visible: false, name: "You are not viewing this."
    visit "/"
    page.should_not have_content("You are not viewing this.")
  end

  scenario "Allow guests to access project pages" do
    Project.make! visible: true, name: "Lorem", description: "Ipsus Literus"
    visit "/"
    click_on "Lorem"
    page.should have_content("Ipsus Literus")
  end

  scenario "Redirect user to home when trying to access invisible project" do
    project = Project.make! visible: false
    visit project_path(project)
    page.should have_content("Start your project")
  end
end
