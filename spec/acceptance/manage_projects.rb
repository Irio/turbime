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

  scenario "Project's owner can edit it's project" do
    user = auth_user
    subject = Project.make!(user: user)
    visit "/"
    click_on subject.name
    click_on "Edit"
    page.should_not have_content("You are not allowed to do this.")
  end

  scenario "Users other than project's owner cannot edit a project" do
    user = auth_user
    subject = Project.make!
    visit "/"
    click_on subject.name
    page.should_not have_content("Edit")

    visit edit_project_path(subject)
    page.should have_content("You are not allowed to do this.")
  end

  scenario "Guests cannot edit projects" do
    subject = Project.make!
    visit edit_project_path(subject)
    page.should have_content("Sign in")
  end
end
