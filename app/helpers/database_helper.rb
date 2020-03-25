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
      rating_value_hash = @custom_ratings_criteria.where(name: rating[:name]).map{|rating| rating.attributes.slice('value')}
      if rating_value_hash.length != 0 
        avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
        ratings_avg[rating[:name]] = avg
      end
    end
    rating_value_hash = @custom_ratings_criteria.where(name: 'ges').map{|rating| rating.attributes.slice('value')}
    if rating_value_hash.length != 0 
      avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
      ges_avg = avg
    end
    if @turn_rating_criteria.present?
      ratings_avg.each do |key, value|
        @turn_rating_criteria.find_by(name: key).update(value: value)
      end
      @turn_rating_criteria.find_by(name: 'ges').update(value: ges_avg)
    else
      ratings_avg.each do |key, value|
        rating_criteria = custom_rating.rating_criteria.find_by(name: key)
        TurnRatingCriterium.create(rating_criteria_id: rating_criteria.id,turn_id: turn.id, admin_id: turn.admin.id, user_id: turn.user_id, game_id: turn.game_id, name: key, value: value)
      end
      TurnRatingCriterium.create(turn_id: turn.id, admin_id: turn.admin.id, user_id: turn.user_id, game_id: turn.game_id, name: 'ges', value: ges_avg)
    end
  end

  def update_user_rating(user, custom_rating, game)
    @ratings = TurnRatingCriterium.where(user_id: user.id)
    ratings_avg = {}
    ratings_alt_avg = {}
    ratings_count = 0

    if @ratings.present?
      ratings_name_hash = @ratings.map{|u| u.attributes.slice('name')}
      uniq_ratings_name = ratings_name_hash.uniq {|rating| rating['name']}
      uniq_ratings_name.each do |rating_hash|
        rating_value_hash = @ratings.where(name: rating_hash['name']).map{|rating| rating.attributes.slice('value')}
        if rating_value_hash.length != 0         
          avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
          ratings_avg[rating_hash['name']] = avg
        end
      end

      ratings_count = @ratings.where(name: 'ges').count       
      if ratings_count > 1
        @ratings_alt = @ratings.where.not(turn_id: @ratings.last.turn_id)
        ratings_name_hash = @ratings_alt.map{|u| u.attributes.slice('name')}
        uniq_ratings_name = ratings_name_hash.uniq {|rating| rating['name']}
        
        uniq_ratings_name.each do |rating_hash|
          rating_value_hash = @ratings_alt.where(name: rating_hash['name']).map{|rating| rating.attributes.slice('value')}
          if rating_value_hash.length != 0   
            avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
            ratings_alt_avg[rating_hash['name']] = avg
          end
        end
      end
    end

    @user_rating_criterium = UserRatingCriterium.find_by(user_id: user.id)
    if @user_rating_criterium && ratings_count > 1
      ratings_avg.each do |key, value|
        if UserRatingCriterium.find_by(user_id: user.id, name: key)
          UserRatingCriterium.find_by(user_id: user.id, name: key).update(value: value)
          if ratings_alt_avg[key].present?
            UserRatingCriterium.find_by(user_id: user.id, name: "change_#{key}").update(value: value - ratings_alt_avg[key])
          end
        else
          UserRatingCriterium.create(user_id: user.id, game_id: game.id, name: key, value: value)
          UserRatingCriterium.create(user_id: user.id, game_id: game.id, name: "change_#{key}", value: value)
        end
      end
    elsif @user_rating_criterium
      ratings_avg.each do |key, value|
        UserRatingCriterium.find_by(user_id: user.id, name: key).update(value: value)
        UserRatingCriterium.find_by(user_id: user.id, name: "change_#{key}").update(value: value)
      end
    else
      ratings_avg.each do |key, value|
        UserRatingCriterium.create(user_id: user.id, game_id: game.id, name: key, value: value)
        UserRatingCriterium.create(user_id: user.id, game_id: game.id, name: "change_#{key}", value: value)
      end
    end
  end


  def update_game_rating(custom_rating, game)
    ratings_avg = {}
    @ratings = TurnRatingCriterium.where(game_id: game.id)
    ratings_name_hash = @ratings.map{|u| u.attributes.slice('name')}
    uniq_ratings_name = ratings_name_hash.uniq {|rating| rating['name']}
    
    uniq_ratings_name.each do |rating_hash|
      rating_value_hash = @ratings.where(name: rating_hash['name']).map{|rating| rating.attributes.slice('value')}
      # avg = rating_value_hash.sum {|rating| rating['value'] unless rating['value'].nil? } / rating_value_hash.length
      count = 0
      values = 0
      rating_value_hash.each do |rating|
        unless rating['value'].nil?
          values += rating['value']
          count += 1
        end
      end
      avg = values / count
      ratings_avg[rating_hash['name']] = avg
    end

    if GameRatingCriterium.find_by(game_id: game.id)
      ratings_avg.each do |key, value|
        GameRatingCriterium.find_by(game_id: game.id, name: key).update(value: value)
      end
    else
      ratings_avg.each do |key, value|
        GameRatingCriterium.create(game_id: game.id, team_id: game.team_id, name: key, value: value)
      end
    end
  end

  def update_team_rating(team, game)
    ratings_avg = {}
    ratings_alt_avg = {}
    ratings_count = 0
    @ratings = GameRatingCriterium.where(team_id: team.id)

    if @ratings.present?
      ratings_name_hash = @ratings.map{|u| u.attributes.slice('name')}
      uniq_ratings_name = ratings_name_hash.uniq {|rating| rating['name']}
      uniq_ratings_name.each do |rating_hash|
        rating_value_hash = @ratings.where(name: rating_hash['name']).map{|rating| rating.attributes.slice('value')}
        avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
        ratings_avg[rating_hash['name']] = avg
      end

      ratings_count = @ratings.where(name: 'ges').count       
      if ratings_count > 1
        @ratings_alt = @ratings.where.not(game_id: @ratings.last.game_id)
        ratings_name_hash = @ratings_alt.map{|u| u.attributes.slice('name')}
        uniq_ratings_name = ratings_name_hash.uniq {|rating| rating['name']}
        
        uniq_ratings_name.each do |rating_hash|
          rating_value_hash = @ratings_alt.where(name: rating_hash['name']).map{|rating| rating.attributes.slice('value')}
          avg = rating_value_hash.sum {|rating| rating['value']} / rating_value_hash.length
          ratings_alt_avg[rating_hash['name']] = avg
        end
      end
    end

    @team_rating_criterium = TeamRatingCriterium.find_by(team_id: team.id)
    if @team_rating_criterium && ratings_count > 1
      ratings_avg.each do |key, value|
        if TeamRatingCriterium.find_by(team_id: team.id, name: key)
          TeamRatingCriterium.find_by(team_id: team.id, name: key).update(value: value)
          if ratings_alt_avg[key].present?
            TeamRatingCriterium.find_by(team_id: team.id, name: "change_#{key}").update(value: value - ratings_alt_avg[key])
          end
        else
          TeamRatingCriterium.create(team_id: team.id, name: key, value: value)
          TeamRatingCriterium.create(team_id: team.id, name: "change_#{key}", value: value)
        end
      end
    elsif @team_rating_criterium
      ratings_avg.each do |key, value|
        TeamRatingCriterium.find_by(team_id: team.id, name: key).update(value: value)
        TeamRatingCriterium.find_by(team_id: team.id, name: "change_#{key}").update(value: value)
      end
    else
      ratings_avg.each do |key, value|
        TeamRatingCriterium.create(team_id: team.id, name: key, value: value)
        TeamRatingCriterium.create(team_id: team.id, name: "change_#{key}", value: value)
      end
    end
  end


  def update_user_rating_old(user)
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

  def update_game_rating_old(game)
    @ratings = TurnRating.where(game_id: game.id)
    if GameRating.find_by(game_id: game.id)
      GameRating.find_by(game_id: game.id).update(ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    else
      GameRating.create(game_id: game.id, team_id: game.team_id, ges: @ratings.average(:ges), body: @ratings.average(:body), creative: @ratings.average(:creative), rhetoric: @ratings.average(:rhetoric), spontan: @ratings.average(:spontan))
    end
  end

  def update_team_rating_old(team)
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
