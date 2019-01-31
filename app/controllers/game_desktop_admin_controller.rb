class GameDesktopAdminController < ApplicationController
  before_action :require_game, :require_admin, :set_vars, except: [:replay]
  before_action :set_turn, only: [:turn, :play, :rate, :rating]
    
  layout 'game_desktop', except: [:load_media]

  def load_media
  end
    
  def redirect
    if @game.state == 'intro'
      @game.update(state: 'wait')
      redirect_to gda_wait_path
    elsif @game.state == 'wait'
      @game.update(state: 'choose')
      redirect_to gda_choose_path
    elsif @game.state == 'choose'
      @game.update(state: 'turn')
      redirect_to gda_turn_path
    elsif @game.state == 'turn'
      @game.update(state: 'play')
      redirect_to gda_play_path
    elsif @game.state == 'play'
      @game.update(state: 'rate')
      redirect_to gda_rate_path
    elsif @game.state == 'rate'
      @game.update(state: 'rating')
      redirect_to gda_rating_path
    elsif @game.state = 'rating'
      @game.update(state: 'choose')
      redirect_to gda_choose_path
    elsif @game.state == 'replay'
      @game.update(state: 'choose')
      redirect_to gda_choose_path
    end
  end

  def intro
  end
    
  def wait
    @count = @game.turns.all.count
  end
    
  def choose
    @turns = @game.turns.where(play:true, played: false).sample(100)
    if @game.turns.count < 2
      game_logout
      @game.destroy
      flash[:danger] = 'Zu wenig Spieler!'
      redirect_to dash_admin_path
      return
    elsif @turns.count > 1
      @game.update(active: false, current_turn: @turns.first.id)
      @turn = Turn.find_by(id: @game.current_turn)
      if !@turn.user_id.nil?
        @user = User.find_by(id: @turn.user_id)
      elsif !@turn.admin_id.nil?
        @user = Admin.find_by(id: @turn.admin_id)
      end
      @word = Word.find_by(id: @turn.word_id)
    elsif @turns.count == 1
      @game.update(active:false, state: 'turn', current_turn: @turns.first.id)
      redirect_to gda_turn_path
      return
    else
      @game.update(active: false, state: 'bestlist')
      redirect_to gda_bestlist_path
      return
    end
  end

  def turn
  end
    
  def play
  end
    
  def rate
  end
    
  def rating
    if @turn.ratings.count == 0
      @turn.destroy
      @game.update(state: 'choose')
      redirect_to gda_choose_path
    else
      @turn.update(played: true)
      update_turn_rating @turn
      update_user_rating @user
      @rating = TurnRating.find_by(turn_id: @turn.id)
    end
  end
    
  def bestlist
    update_game_rating @game
    @team = Team.find(@game.team_id)
    update_team_rating @team
    @list = TurnRating.where(game_id: @game.id).map{|t| {:user_id => t.user_id, :admin_id => t.admin_id, :turn_id => t.turn_id, :ges => t.ges, }}
    @list.sort_by!{|e| -e[:ges]}
    if @list.length == 0
        game_logout
        @game.destroy
        redirect_to dash_admin_path
        return
    end
    if @list.length >= 1
        if @list.first[:user_id].nil?
          @user1 = Admin.find(@list.first[:admin_id])
        else
          @user1 = User.find(@list.first[:user_id])
        end
        @turn = Turn.find(@list.first[:turn_id])
        @turn.update(place: 1)
        @rat1 = @list.first[:ges]
    end
    if @list.length >= 2
        if @list.second[:user_id].nil?
          @user2 = Admin.find(@list.second[:admin_id])
        else
          @user2 = User.find(@list.second[:user_id])
        end
        @turn = Turn.find(@list.second[:turn_id])
        @turn.update(place: 2)
        @rat2 = @list.second[:ges]
    end
    if @list.length >= 3
        if @list.third[:user_id].nil?
          @user3 = Admin.find(@list.third[:admin_id])
        else
          @user3 = User.find(@list.third[:user_id])
        end
        @turn = Turn.find(@list.third[:turn_id])
        @turn.update(place: 3)
        @rat3 = @list.third[:ges]
    end
  end
    
  def ended
    @game.update(state: 'ended')
    @state = @game.state
    game_logout
    redirect_to dash_admin_path
  end
    
  def replay
    @game = Game.find(params[:game_id])
    @admin = current_admin
    @game.update(state: 'replay')
    @game1 = Game.where(password: @game.password, active: true).first
    if @game1
      game_logout
      game_login @game1
      redirect_to gda_wait_path
    else
      @game1 = Game.create(admin_id: @admin.id, team_id: @game.team_id, active: true, state: 'wait', password: @game.password)
      game_logout
      game_login @game1
      redirect_to gda_wait_path
    end
    
  end
    
  private
    def set_vars
      @game = current_game
      @admin = current_admin
      @state = @game.state
    end
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      if !@turn.user_id.nil?
        @user = User.find_by(id: @turn.user_id)
      elsif !@turn.admin_id.nil?
        @user = Admin.find_by(id: @turn.admin_id)
      end
      @word = Word.find_by(id: @turn.word_id)
    end
end