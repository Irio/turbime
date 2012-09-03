# encoding: UTF-8

User.create([
  {name: "Juquinha da Rocha", email: "juquinha@turbi.me", password: "123123"},
  {name: "Irio Irineu Musskopf Junior", email: "iirineu@gmail.com", password: "123123"},
  {name: "Josemar Luedke", email: "josemarluedke@gmail.com", password: "123123"},
  {name: "Marcio Marques", email: "marcio@caixadeideias.com.br", password: "123123"},
  {name: "Sérgio Schnorr", email: "sergio@sergiosj.com", password: "123123"}
])

Project.create([
  {visible: true, code_funded: "https://github.com/Irio/ruby-tmdb/tree/api3", user_id: User.all[1].id, name: "Better manager on Rails Girls site", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem facilisis semper ac in est.", expires_at: 2.weeks.from_now, headline: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viv.", video: "http://vimeo.com/17752439", repository: "https://github.com/plus8star/RailsGirls", goal: 2000.0},
  {visible: true, user_id: User.all[2].id, name: "Implement MoIP on Catarse", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor.", expires_at: 4.weeks.from_now, headline: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit.", video: "http://vimeo.com/35305036", repository: "https://github.com/plus8star/RailsGirls", goal: 1000.0},
  {visible: true, user_id: User.all[0].id, name: "Homebrew deserves a integration with Linux", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.", expires_at: 6.weeks.from_now, headline: "Lorem ipsum dolor sit.", video: "http://vimeo.com/42305030", repository: "https://github.com/mxcl/homebrew", goal: 1000.0},
  {visible: true, user_id: User.all[0].id, name: "Turbi deserves a lorem", description: "Lorem ipsum dolor sit amet, a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.", expires_at: 4.weeks.from_now, headline: "Lorem ip sdfsdf sdf dsfsum dolor sit.", video: "http://vimeo.com/48297255", repository: "https://github.com/mxcl/homebrew", goal: 1000.0},
  {visible: true, user_id: User.all[0].id, name: "Turbi some lorem", description: "Lorem ipsum dolor sit amet, a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.", expires_at: 4.weeks.from_now, headline: "Lorem ip sdfsdf sdf dsfsum dolor sit.", video: "http://vimeo.com/6563331", repository: "https://github.com/mxcl/homebrew", goal: 20.0},
  {visible: true, user_id: User.all[0].id, name: "Turbi deserves other lorem", description: "Lorem ipsum dolor sit amet, a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.", expires_at: 9.weeks.from_now, headline: "Lorem ip sdfsdf sdf dsfsum dolor sit.", video: "http://vimeo.com/15083781", repository: "https://github.com/mxcl/homebrew", goal: 10000.0}
])

15.times do
  project = Project.all[0]
  support = Support.create(
    project_id: project.id, amount: 500, user_id: User.last.id, terms: "1"
  )
  support.confirm!
end

20.times do
  project = Project.all[1]
  support = Support.create(
    project_id: project.id, amount: 13, user_id: User.last.id, terms: "1"
  )
  support.confirm!
end

20.times do
  project = Project.all[2]
  support = Support.create(
    project_id: project.id, amount: 500, user_id: User.last.id, terms: "1"
  )
  support.confirm!
end

20.times do
  project = Project.all[4]
  support = Support.create(
    project_id: project.id, amount: 900, user_id: User.last.id, terms: "1"
  )
  support.confirm!
end

yesterday = Date.yesterday
Delorean.time_travel_to("1 month ago") do
  projects = Project.all
  projects[0].update_attributes(expires_at: yesterday)
  projects[3].update_attributes(expires_at: yesterday)
  projects[4].update_attributes(expires_at: yesterday)
end
