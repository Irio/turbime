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
    page.should have_content("401")
  end

  scenario "Guests cannot edit projects" do
    subject = Project.make!
    visit edit_project_path(subject)
    page.should have_content("401")
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

  scenario "Code funded input must not appear when creating a project" do
    user = auth_user
    visit "/"
    click_on "Start your project"
    page.should_not have_css("input#project_code_funded")
  end

  scenario "User should know if the project is successful" do
    user = auth_user
    project = Project.make! visible: true, goal: 1000
    11.times { Support.make!(user: user, project: project, amount: 100).confirm!  }

    past_date = -1.month.from_now
    Delorean.time_travel_to("2 months ago") do
      project.update_column :expires_at, past_date
    end

    visit project_path(project)
    page.should have_css(".donate-button.successful")
    page.should_not have_css(".donate-button.not_successful")
    page.should have_content("Funded")
  end

  scenario "User should know if the project is not successful" do
    user = auth_user
    project = Project.make! visible: true, goal: 1000
    5.times { Support.make!(user: user, project: project, amount: 100).confirm! }

    past_date = -1.month.from_now
    Delorean.time_travel_to("2 months ago") do
      project.update_column :expires_at, past_date
    end

    visit project_path(project)
    page.should_not have_css(".donate-button.successful")
    page.should have_css(".donate-button.not_successful")
    page.should have_content("Not Funded")
  end

  scenario "Should don't have new support link if project is expired" do
    user = auth_user
    past_date = -1.month.from_now
    Delorean.time_travel_to("2 months ago") do
      @project = Project.make! visible: true, goal: 1000, expires_at: past_date
    end
    visit project_path(@project)
    find('a#donate')['href'].should_not == "http://www.example.com#{new_project_support_path(@project)}"
  end

  scenario "Should have new support link for back a project" do
    user = auth_user
    project = Project.make! visible: true, goal: 1000
    visit project_path(project)
    find('a#donate')['href'].should == "http://www.example.com#{new_project_support_path(project)}"
  end

end
