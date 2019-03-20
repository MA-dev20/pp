module DatabaseHelper
  
  def update_turn_rating(turn)
    @ratings = turn.ratings.all
    if TurnRating.find_by(turn_id: turn.id)
      TurnRating.find_by(turn_id: turn.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      TurnRating.create(turn_id: turn.id, admin_id: turn.admin_id, user_id: turn.user_id, game_id: turn.game_id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end

  def update_user_rating(user)
    @ratings = TurnRating.where(user_id: user.id)
    if UserRating.find_by(user_id: user.id)
      UserRating.find_by(user_id: user.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      UserRating.create(user_id: user.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end

  def update_game_rating(game)
    @ratings = TurnRating.where(game_id: game.id)
    if GameRating.find_by(game_id: game.id)
      GameRating.find_by(game_id: game.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      GameRating.create(game_id: game.id, team_id: game.team_id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end

  def update_team_rating(team)
    @ratings = GameRating.where(team_id: team.id)
    if TeamRating.find_by(team_id: team.id)
      TeamRating.find_by(team_id: team.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      TeamRating.create(team_id: team.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end
end
