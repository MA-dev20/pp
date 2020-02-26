module DatabaseHelper
  
  def update_turn_rating_old(turn)
    @ratings = turn.ratings.all
    if TurnRating.find_by(turn_id: turn.id)
      TurnRating.find_by(turn_id: turn.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      TurnRating.create(turn_id: turn.id, admin_id: turn.admin_id, user_id: turn.user_id, game_id: turn.game_id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end

  def update_turn_rating(turn, custom_rating)
    @custom_ratings_criteria = turn.custom_rating_criteria.all
    @turn_rating_criteria = TurnRatingCriterium.where(turn_id: turn.id)
    ratings_avg = {}
    custom_rating.rating_criteria.each do |rating|
      rating_value_hash = @custom_ratings_criteria.find_by(name: rating[:name]).attributes.slice('value')
      avg = rating_value_hash.values.inject(0, :+) / rating_value_hash.length
      ratings_avg[rating[:name]] = avg
    end
    rating_value_hash = @custom_ratings_criteria.find_by(name: 'ges').attributes.slice('value')
    avg = rating_value_hash.values.inject(0, :+) / rating_value_hash.length
    ges_avg = avg

    
    if @turn_rating_criteria
      ratings_avg.each do |key, value|
        @turn_rating_criteria.find_by(name: key).update(value: value)
      end
      @turn_rating_criteria.find_by(name: 'ges').update(value: ges_avg)

      # @turn_rating_criteria.update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      ratings_avg.each do |key, value|
        # @turn_rating_criteria.find_by(name: key).update(value: value)
        rating_criteria = custom_rating.rating_criteria.find_by(name: key)
        TurnRatingCriterium.create(rating_criteria_id: rating_criteria.id,turn_id: turn.id, admin_id: turn.admin.id, user_id: turn.user_id, game_id: turn.game_id, name: key, value: value)
      end
      TurnRatingCriterium.create(turn_id: turn.id, admin_id: turn.admin.id, user_id: turn.user_id, game_id: turn.game_id, name: 'ges', value: ges_avg)

      # TurnRating.create(turn_id: turn.id, admin_id: turn.admin_id, user_id: turn.user_id, game_id: turn.game_id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end

    # debugger

  end

  def update_user_rating(user)
    @ratings = TurnRating.where(user_id: user.id)
    if UserRating.find_by(user_id: user.id) && @ratings.count > 1
      @ratings_alt = @ratings.where.not(id: @ratings.last.id)
      UserRating.find_by(user_id: user.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges) - @ratings_alt.average(:ges), change_body: @ratings.average(:body) - @ratings_alt.average(:body), change_creative: @ratings.average(:creative) - @ratings_alt.average(:creative), change_rhetoric: @ratings.average(:rhetoric) - @ratings_alt.average(:rhetoric), change_spontan: @ratings.average(:spontan) - @ratings_alt.average(:spontan))
	elsif UserRating.find_by(user_id: user.id)
	  UserRating.find_by(user_id: user.id).update(user_id: user.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges), change_body: @ratings.average(:body), change_creative: @ratings.average(:creative), change_rhetoric: @ratings.average(:rhetoric), change_spontan: @ratings.average(:spontan))
	else
      UserRating.create(user_id: user.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges), change_body: @ratings.average(:body), change_creative: @ratings.average(:creative), change_rhetoric: @ratings.average(:rhetoric), change_spontan: @ratings.average(:spontan))
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
    if TeamRating.find_by(team_id: team.id) && @ratings.count > 1
      @ratings_alt = @ratings.where.not(id: @ratings.last.id)
      TeamRating.find_by(team_id: team.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges) - @ratings_alt.average(:ges), change_body: @ratings.average(:body) - @ratings_alt.average(:body), change_creative: @ratings.average(:creative) - @ratings_alt.average(:creative), change_rhetoric: @ratings.average(:rhetoric) - @ratings_alt.average(:rhetoric), change_spontan: @ratings.average(:spontan) - @ratings_alt.average(:spontan))
    elsif TeamRating.find_by(team_id: team.id)
	  TeamRating.find_by(team_id: team.id).update(team_id: team.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges), change_body: @ratings.average(:body), change_creative: @ratings.average(:creative), change_rhetoric: @ratings.average(:rhetoric), change_spontan: @ratings.average(:spontan))
	else
      TeamRating.create(team_id: team.id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan), change_ges: @ratings.average(:ges), change_body: @ratings.average(:body), change_creative: @ratings.average(:creative), change_rhetoric: @ratings.average(:rhetoric), change_spontan: @ratings.average(:spontan))
    end
  end
end
