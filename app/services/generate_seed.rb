class GenerateSeed
  def self.exec
    generate_users_teams
    generate_rand_apply
  end

  private
  def self.generate_users_teams
     12.times do |i|
       u = User.create!(email: "test#{i}@test.com", password: "asdasd", password_confirmation: "asdasd", name: "유저-#{i}")
       t = Team.create!(name: "#{i}번째 팀", description: "#{i}번째 설명입니다.")
       TeamUser.create!(team: t, user: u, role: :captain)
       u.update!(team: t)
     end
  end

  def self.generate_rand_apply
    50.times do |i|
      u = User.all.sample
      t = Team.all.sample
      unless u.my_team?(t)
        TeamUser.create!(user: u, team: t, role: :apply) unless TeamUser.where(user: u, team: t).present?
      end
    end
  end

end
