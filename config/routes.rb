Rails.application.routes.draw do
  get 'landing/index'
    
  root 'landing#index'
    
  get 'coaches/register', to: 'landing#register_coach', as: 'register_coach'
  get 'companies/register', to: 'landing#register_company', as: 'register_company'
  get 'coaches/info', to: 'landing#coach', as: 'coach_info'
  get 'companies/info', to: 'landing#company', as: 'company_info'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
########
# Game #
########

#################
# Admin Desktop #
#################

  get 'games/intro', to: 'game_desktop_admin#intro', as: 'gda_intro'
  get 'games/wait', to: 'game_desktop_admin#wait', as: 'gda_wait'
  get 'games/choose', to: 'game_desktop_admin#choose', as: 'gda_choose'
  get 'games/turn', to: 'game_desktop_admin#turn', as: 'gda_turn'
  get 'games/play', to: 'game_desktop_admin#play', as: 'gda_play'
  get 'games/rate', to: 'game_desktop_admin#rate', as: 'gda_rate'
  get 'games/rating', to: 'game_desktop_admin#rating', as: 'gda_rating'
  get 'games/bestlist', to: 'game_desktop_admin#bestlist', as: 'gda_bestlist'
  get 'games/ended', to: 'game_desktop_admin#ended', as: 'gda_ended'
  get 'games/:game_id/replay', to: 'game_desktop_admin#replay', as: 'gda_replay'
    
  get 'games/redirect', to: 'game_desktop_admin#redirect', as: 'gda_redirect'

################
# Admin Mobile #
################

  get 'mobile/admin/avatar', to: 'game_mobile_admin#new_avatar', as: 'gma_new_avatar'
  post 'mobile/admin/avatar', to: 'game_mobile_admin#create_avatar'
  get 'mobile/admin/new_turn', to: 'game_mobile_admin#new_turn', as: 'gma_new_turn'
  post 'mobile/admin/new_turn', to: 'game_mobile_admin#create_turn'
    
  get 'mobile/admin/intro', to: 'game_mobile_admin#intro', as: 'gma_intro'
  get 'mobile/admin/wait', to: 'game_mobile_admin#wait', as: 'gma_wait'
  get 'mobile/admin/choose', to: 'game_mobile_admin#choose', as: 'gma_choose'
  get 'mobile/admin/turn', to: 'game_mobile_admin#turn', as: 'gma_turn'
  get 'mobile/admin/play', to: 'game_mobile_admin#play', as: 'gma_play'
  get 'mobile/admin/rate', to: 'game_mobile_admin#rate', as: 'gma_rate'
  get 'mobile/admin/rated', to: 'game_mobile_admin#rated', as: 'gma_rated'
  get 'mobile/admin/rating', to: 'game_mobile_admin#rating', as: 'gma_rating'
  get 'mobile/admin/bestlist', to: 'game_mobile_admin#bestlist', as: 'gma_bestlist'
  get 'mobile/:game_id/admin/:admin_id/replay', to: 'game_mobile_admin#replay', as: 'gma_replay'
  get 'mobile/admin/ended', to: 'game_mobile_admin#ended', as: 'gma_ended'
    
  get 'mobile/admin/redirect', to: 'game_mobile_admin#redirect', as: 'gma_redirect'
    
###############
# User Mobile #
###############
    
  get 'mobile/user/name', to: 'game_mobile_user#new_name', as: 'gmu_new_name'
  post 'mobile/user/name', to: 'game_mobile_user#create_name'
  
  get 'mobile/user/password', to: 'game_mobile_user#new_password', as: 'gmu_new_password'
  post 'mobile/user/password', to: 'game_mobile_user#create_password'
    
  get 'mobile/user/company', to: 'game_mobile_user#new_company', as: 'gmu_new_company'
  post 'mobile/user/company', to: 'game_mobile_user#create_company'
    
  get 'mobile/user/avatar', to: 'game_mobile_user#new_avatar', as: 'gmu_new_avatar'
  post 'mobile/user/avatar', to: 'game_mobile_user#create_avatar'
    
  get 'mobile/user/game/new_turn', to: 'game_mobile_user#new_turn', as: 'gmu_new_turn'
  post 'mobile/user/game/new_turn', to: 'game_mobile_user#create_turn'
    
  get 'mobile/user/game/wait', to: 'game_mobile_user#wait', as: 'gmu_wait'
  get 'mobile/user/game/choose', to: 'game_mobile_user#choose', as: 'gmu_choose'
  get 'mobile/user/game/turn', to: 'game_mobile_user#turn', as: 'gmu_turn'
  get 'mobile/user/game/rate', to: 'game_mobile_user#rate', as: 'gmu_rate'
  get 'mobile/user/game/rated', to: 'game_mobile_user#rated', as: 'gmu_rated'
  get 'mobile/user/game/rating', to: 'game_mobile_user#rating', as: 'gmu_rating'
  get 'mobile/user/game/bestlist', to: 'game_mobile_user#bestlist', as: 'gmu_bestlist'
  get 'mobile/user/:user_id/game/:game_id/replay', to: 'game_mobile_user#replay', as: 'gmu_replay'
  get 'mobile/user/game/ended', to: 'game_mobile_user#ended', as: 'gmu_ended'
  
    
####################################################################################
#############
# Dashboard #
#############

##############
# Backoffice #
##############
    
  get 'backoffice', to: 'backoffice#index', as: 'backoffice'
  get 'backoffice/coaches', to: 'backoffice#coaches', as: 'backoffice_coaches'
  get 'backoffice/companies', to: 'backoffice#companies', as: 'backoffice_companies'
  get 'backoffice/words', to: 'backoffice#words', as: 'backoffice_words'

#########
# Admin #
#########
    
    get 'admin/dash/', to: 'dash_admin#index', as: 'dash_admin'
    get 'admin/dash/teams/:team_id/games', to: 'dash_admin#games', as: 'dash_admin_games'
    
    get 'admin/dash/teams', to: 'dash_admin#teams', as: 'dash_admin_teams'
    get 'admin/dash/teams/:team_id/stats', to: 'dash_admin#team_stats', as: 'dash_admin_team_stats'
    
    get 'admin/dash/users', to: 'dash_admin#users', as: 'dash_admin_users'
    get 'admin/dash/teams/:team_id/users', to: 'dash_admin#team_users', as: 'dash_admin_team_users'
    get 'admins/dash/teams/:team_id/users/:user_id/stats', to: 'dash_admin#user_stats', as: 'dash_admin_user_stats'
    
    get 'admins/dash/account', to: 'dash_admin#account', as: 'dash_admin_account'
    
    

############
# Sessions #
############

#########
# Admin #
#########
    
  get 'coaches/login', to: 'admin_session#new_coach', as: 'login_coach'
  post 'coaches/login', to: 'admin_session#create_coach'
  get 'companies/login', to: 'admin_session#new_company', as: 'login_company'
  post 'companies/login', to: 'admin_session#create_coach'
    
  get 'admin/logout', to: 'admin_session#destroy', as: 'logout_admin'

########
# Root #
########
    
  get 'root/login', to: 'root_session#new', as: 'login_root'
  post 'root/login', to: 'root_session#create'

  get 'root/logout', to: 'root_session#destroy', as: 'logout_root'

########
# Game #
########
    
  get 'games/login', to: 'game_session#new', as: 'login_game'
  post 'games/login', to: 'game_session#create'
##################
# CRUD Ressource #
##################

#########
# Admin #
#########
    
  get 'coaches/new', to: 'admins#new_coach', as: 'new_coach'
  post 'coaches/new', to: 'admins#create_coach'
  get 'companies/new', to: 'admins#new_company', as: 'new_company'
  post 'companies/new', to: 'admins#create_company'
    
  get 'admins/:admin_id/edit', to: 'admins#edit', as: 'edit_admin'
  post 'admins/:admin_id/edit', to: 'admins#update'
    
  get 'admins/:admin_id/destroy', to: 'admins#destroy', as: 'destroy_admin'
    
########
# Team #
########
    
  get 'teams/new', to: 'teams#new', as: 'new_team'
  post 'teams/new', to: 'teams#create'
    
  get 'teams/new_game', to: 'teams#new_game', as: 'new_team_game'
  post 'teams/new_game', to: 'teams#create_game'
    
  get 'teams/:team_id/destroy', to: 'teams#destroy', as: 'destroy_team'

########
# Game #
########
    
  get 'games/new', to: 'games#new', as: 'new_game'
  post 'games/new', to: 'games#create'

########
# User #
########
    
  get 'users/:user_id/destroy', to: 'users#destroy', as: 'destroy_user'

##########
# Rating #
##########
    
  get 'turns/:turn_id/ratings/new', to: 'ratings#new', as: 'new_rating'
  post 'turns/:turn_id/ratings/new', to: 'ratings#create'
    
  get 'turns/:turn_id/user/ratings/new', to: 'ratings#new_user', as: 'new_rating_user'
  post 'turns/:turn_id/user/ratings/new', to: 'ratings#create_user'

########
# Word #
########
    
  get 'words/new', to: 'words#new', as: 'new_word'
  post 'words/new', to: 'words#create'

  get 'words/:word_id/edit', to: 'words#edit', as: 'edit_word'
  post 'words/:word_id/edit', to: 'words#update'
    
  get 'words/:word_id/destroy', to: 'words#destroy', as: 'destroy_word'

end
