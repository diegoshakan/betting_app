# db/seeds.rb
User.create!(email: "admin@example.com", password: "password", admin: true)
User.create!(email: "user@example.com", password: "password", admin: false)

teams = [
  { name: "Flamengo", division: "Série A" },
  { name: "Palmeiras", division: "Série A" },
  { name: "Corinthians", division: "Série A" },
  { name: "São Paulo", division: "Série A" },
  { name: "Santos", division: "Série A" },
  { name: "Grêmio", division: "Série A" },
  { name: "Internacional", division: "Série A" },
  { name: "Atlético-MG", division: "Série A" },
  { name: "Cruzeiro", division: "Série A" },
  { name: "Botafogo", division: "Série A" },
  { name: "Vasco", division: "Série A" },
  { name: "Bahia", division: "Série A" },
  { name: "Fluminense", division: "Série A" },
  { name: "Athletico-PR", division: "Série A" },
  { name: "Sport", division: "Série A" },
  { name: "Vitória", division: "Série A" },
  { name: "Coritiba", division: "Série A" },
  { name: "Ceará", division: "Série A" },
  { name: "Fortaleza", division: "Série A" },
  { name: "Goiás", division: "Série A" },
]

Team.destroy_all # Limpa times existentes
teams.each { |team| Team.create!(team) }

Round.destroy_all # Limpa rodadas existentes
10.times do |round_number|
  round = Round.create!(number: round_number + 1)
  team_ids = Team.pluck(:id).shuffle
  10.times do |i|
    Game.create!(
      round: round,
      home_team_id: team_ids[i * 2],
      away_team_id: team_ids[i * 2 + 1]
    )
  end
end

puts "Seeds criados: 2 usuários, 20 times, 10 rodadas com 10 jogos cada."