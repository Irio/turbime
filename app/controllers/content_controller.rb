class ContentController < ApplicationController
  def home
    @projects = []
    0.upto(10) do
      @projects.push Project.new(name: "NOME", description: "descricao", expires_at: rand(365).days.from_now, goal: rand(99))
    end
  end
  def u
    @user = User.first
    @user.projects = []
    0.upto(10) do
      @user.projects.push Project.new(name: "NOME", description: "descricao", expires_at: rand(365).days.from_now, goal: rand(99))
    end
  end
  def doacao
    
  end
end
