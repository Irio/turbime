require 'machinist/active_record'

# Add your blueprints here.

User.blueprint do
  name {'Josemar Davi Luedke'}
  email {'josemarluedke@gmail.com'}
  password {'josemar'}
  password_confirmation {'josemar'}
end

Authorization.blueprint do
  user {User.make!}
  provider {"facebook"}
  uid {10000}
end

Project.blueprint do
  user {User.make!}
  name {"Awesome Project"}
  description {"Some description."}
  headline {"Headline of this project."}
  repository {"http://github.com/awesome/project"}
  goal {1000}
  expires_at {1.month.from_now}
  video {"http://vimeo.com/28220980"}
end
