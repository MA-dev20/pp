class DashAdminController < ApplicationController
  before_action :authenticate_admin!, :set_admin , unless: :skip_action?
  before_action :set_team, only: [:games, :team_stats, :team_users, :user_stats, :compare_user_stats]
  before_action :set_user, only: [:user_stats, :compare_user_stats]
  skip_before_action :check_expiration_date, only: :billing
  layout 'dash_admin'
    
  def index
    if params[:team_id]
      @team = Team.find(params[:team_id])
    end
  end
    
  def teams
  end
    
  def team_stats
    @rating = @team.team_rating
    @gameratings = @team.game_ratings.last(7)
    @count = 1
    if !@rating
      flash[:pop_up] = "Ups, für dieses Team liegen noch keine Statistiken vor.;- Da müsst ihr wohl erst noch eine Runde spielen. -;Let's Play"
      redirect_to dash_admin_teams_path
    end
  end
    
  def users
    if params[:team_id]
      @team = Team.find(params[:team_id])
      @users = @team.users
    else
      @users = @admin.users
    end
  end
    
  def user_stats
    @users = @admin.users
    @turns = @user.turns
    @turns_rating = @user.turn_ratings.last(7)
    @rating = @user.user_rating
    if !@rating
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      redirect_to dash_admin_users_path
    end
  end
    
  def compare_user_stats
    @users = @admin.users
    @turns = @user.turns
    @turns_rating = @user.turn_ratings.last(7)
    @rating = @user.user_rating
      
    @user1 = User.find(params[:compare_user_id])
  end
    
  def account
  end
    
  def verification
    @token = params[:token]     
  end

  def billing

 Stripe.api_key = 'sk_test_zPJA7u8PtoHc4MdDUsTQNU8g'

    @credit_cards= @admin.cards.all

    begin
   @invoice = Stripe::Invoice.list({
                                       customer: @admin.stripe_id
                                   })
    rescue => e
      flash[:error] = "Error in fetching invoices"
   end

      # @invoice =@admin.invoices.all
    # @invoices= Stripe::InvoiceItem.retrieve(
    #    Invoice.where(stripe_invoice_id: @invoice.id)  
    # )
    # Invoice.create(plan_id: @invoice.values[1][0].id , 
    #   invoice_interval: @invoice.values[1][0].lines.data[0].plan.interval ,
    #   invoice_currency:@invoice.values[1][0].lines.data[0].plan.currency  ,
    #   amount_paid: @invoice.values[1][0].lines.data[0].plan.amount )

    
  end
  
  private
    def set_admin
      @admin = current_admin
      @teams = @admin.teams
    end
    
    def set_team
      @team = Team.find(params[:team_id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end

   def skip_action?
    (params[:token]) ? true : false  
   end

end
