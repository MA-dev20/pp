namespace :game_activity do
  desc "TODO"
  task remove_game_due_to_inactivity: :environment do
  	@games = Game.where('id not in (?)',Game.where(updated_at: (Time.now - 1.hours)..Time.now).pluck(:id))
  	puts "found some games which are inactive " if @games.length > 0
  	@games.each do |game|
  		game.turns.destroy_all if game.active == false
  		game.update(active: true)  if game.active == false
  	end
  end
end
