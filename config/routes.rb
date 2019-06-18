Rails.application.routes.draw do
  devise_for :games
  devise_for :users
  devise_for :admins, controllers: { registrations: 'admins/registrations', sessions: 'devise_user/sessions', passwords: 'admins/passwords' }
  resource :cards
  resource :plans

  # root to: 'games#show'
  patch 'game_mobile_user/accept_user/:user_id', to: 'game_mobile_user#accept_user', as: 'accept_user'
  patch 'game_mobile_user/reject_user/:user_id', to: 'game_mobile_user#reject_user', as: 'reject_user'

  get 'dash/stats', to: 'user/dash_user#stats', as: 'dash_user_stats'
  post 'dash/filter_videos', to:  'user/dash_user#filter_videos', as: 'user_filter_videos'
  get 'dash/videos', to: 'user/dash_user#tool', as: 'dash_user_video_tool'
  get 'dash/stats/turns/:turn_id', to: 'user/dash_user#turn_show', as: 'dash_user_show_turn'
  delete 'dash/stats/turns/:turn_id', to: 'user/dash_user#delete_video', as: 'dash_user_delete_video'
  get 'dash/account', to: 'user/dash_user#account', as: 'dash_user_account'
  put 'dash/account', to: 'user/dash_user#update_user', as: 'dash_user_account_update'
 


  get 'landing/index'
  get 'landing/price', to: 'landing#price', as: 'price'
  get 'dash_admin/dash_admin_price', to: 'dash_admin#dash_admin_price', as: 'dash_admin_price'
  get 'landing/product', to: 'landing#product', as: 'product'
  root 'landing#index'
  patch 'verification/verify_token' ,to: 'verification#verify_token' , as:'verify_token'
  get 'admins/register', to: 'landing#register', as: 'register'
  get 'admins/sign_up/:v_id', to: 'landing#sign_up', as: 'edit_admin'
  get 'admins/signup/:v_id', to: 'landing#signup' , as: 'edit_next_admin'
  patch 'admins/update_admin/:v_id', to: 'landing#update_admin', as: 'update_admin'
  patch 'admins/update_admin_details/:v_id', to: 'landing#update_admin_details', as: 'update_admin_details'

  get 'coaches/info', to: 'landing#coach', as: 'coach_info'
  get '/verfication/:token' , to: 'verification#token' , as: 'verification_token'
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
  get 'games/error', to: 'game_desktop_admin#error', as: 'gea_turn'
  get 'games/play', to: 'game_desktop_admin#play', as: 'gda_play'
  get 'games/rate', to: 'game_desktop_admin#rate', as: 'gda_rate'
  get 'games/rating', to: 'game_desktop_admin#rating', as: 'gda_rating'
  get 'games/bestlist', to: 'game_desktop_admin#bestlist', as: 'gda_bestlist'
  get 'games/ended', to: 'game_desktop_admin#ended', as: 'gda_ended'
  get 'games/replay', to: 'game_desktop_admin#replay', as: 'gda_replay'
    
  get 'games/after_rating', to: 'game_desktop_admin#after_rating', as: 'gda_after_rating'

################
# Admin Mobile #
################

  get 'mobile/admins/:password', to: 'game_mobile_admin#new', as: 'gma_start'
  post 'mobile/admins/:password', to: 'game_mobile_admin#create'
  get 'mobile/admin/avatar', to: 'game_mobile_admin#new_avatar', as: 'gma_new_avatar'
  post 'mobile/admin/avatar', to: 'game_mobile_admin#create_avatar'
  get 'mobile/admin/new_turn', to: 'game_mobile_admin#new_turn', as: 'gma_new_turn'
  post 'mobile/admin/new_turn', to: 'game_mobile_admin#create_turn'
    
  get 'mobile/admin/intro', to: 'game_mobile_admin#intro', as: 'gma_intro'
  get 'mobile/admin/wait', to: 'game_mobile_admin#wait', as: 'gma_wait'
  get 'mobile/admin/error', to: 'game_mobile_admin#error', as: 'gea_mobile'
  get 'mobile/admin/choose', to: 'game_mobile_admin#choose', as: 'gma_choose'
  get 'mobile/admin/choosen/:turn_id', to: 'game_mobile_admin#choosen', as: 'gma_choosen'
  get 'mobile/admin/turn', to: 'game_mobile_admin#turn', as: 'gma_turn'
  get 'mobile/admin/play', to: 'game_mobile_admin#play', as: 'gma_play'
  post 'mobile/admin/upload', to: 'game_mobile_admin#save_video', as: 'gpitchsave_play'
  get 'mobile/admin/video_cancel', to: 'game_mobile_admin#video_cancel',as: 'cancel_video_uploading'
  get 'mobile/admin/rate', to: 'game_mobile_admin#rate', as: 'gma_rate'
  get 'mobile/admin/rated', to: 'game_mobile_admin#rated', as: 'gma_rated'
  get 'mobile/admin/rating', to: 'game_mobile_admin#rating', as: 'gma_rating'
  get 'mobile/admin/bestlist', to: 'game_mobile_admin#bestlist', as: 'gma_bestlist'
  get 'mobile/admin/replay', to: 'game_mobile_admin#replay', as: 'gma_replay'
  get 'mobile/admin/ended', to: 'game_mobile_admin#ended', as: 'gma_ended'
    
  get 'mobile/admin/after_rating', to: 'game_mobile_admin#after_rating', as: 'gma_after_rating'
    
###############
# User Mobile #
###############
    
  get 'mobile/user/game', to: 'game_mobile_user#new', as: 'gmu_password'
  post 'mobile/user/game', to: 'game_mobile_user#create'

  get 'mobile/user/name', to: 'game_mobile_user#new_name', as: 'gmu_new_name'
  post 'mobile/user/name', to: 'game_mobile_user#create_name'
    
  get 'mobile/user/company', to: 'game_mobile_user#new_company', as: 'gmu_new_company'
  post 'mobile/user/company', to: 'game_mobile_user#create_company'
    
  get 'mobile/user/avatar', to: 'game_mobile_user#new_avatar', as: 'gmu_new_avatar'
  post 'mobile/user/avatar', to: 'game_mobile_user#create_avatar'
    
  get 'mobile/user/game/new_turn', to: 'game_mobile_user#new_turn', as: 'gmu_new_turn'
  post 'mobile/user/game/new_turn', to: 'game_mobile_user#create_turn'
  get 'mobile/user/game/vidoe_uploading', to: 'game_mobile_user#video_uploading', as: 'gmu_video_check'
  get 'mobile/user/game/wait', to: 'game_mobile_user#wait', as: 'gmu_wait'
  get 'mobile/user/game/choose', to: 'game_mobile_user#choose', as: 'gmu_choose'
  get 'mobile/user/game/choosen/:turn_id', to: 'game_mobile_user#choosen', as: 'gmu_choosen'
  get 'mobile/user/game/turn', to: 'game_mobile_user#turn', as: 'gmu_turn'
  get 'mobile/user/game/play', to: 'game_mobile_user#play', as: 'gmu_play'
  get 'mobile/user/game/rate', to: 'game_mobile_user#rate', as: 'gmu_rate'
  get 'mobile/user/game/rated', to: 'game_mobile_user#rated', as: 'gmu_rated'
  get 'mobile/user/game/rating', to: 'game_mobile_user#rating', as: 'gmu_rating'
  get 'mobile/user/game/bestlist', to: 'game_mobile_user#bestlist', as: 'gmu_bestlist'
  get 'mobile/user/game/replay', to: 'game_mobile_user#replay', as: 'gmu_replay'
  get 'mobile/user/game/ended', to: 'game_mobile_user#ended', as: 'gmu_ended'
  
    
####################################################################################
#############
# Dashboard #
#############

##############
# Backoffice #
##############
    
  get 'backoffice', to: 'backoffice#index', as: 'backoffice'
  get 'backoffice/admins', to: 'backoffice#admins', as: 'backoffice_admins'
  get 'backoffice/baskets/', to: 'backoffice#baskets', as: 'backoffice_baskets'
  get 'backoffice/baskets/:admin_id', to: 'backoffice#baskets', as: 'backoffice_admin_baskets'
  get 'backoffice/words/:basket_id', to: 'backoffice#words', as: 'backoffice_words'
    
  # Catchword Basket #
    
  get 'catchword_basket/new', to: 'catchwords_basket#new', as: 'new_basket'
  post 'catchword_basket/new', to: 'catchwords_basket#create'
  get 'catchword_basket/:basket_id/edit', to: 'catchwords_basket#edit', as: 'edit_basket'
  post 'catchword_basket/:basket_id/update', to: 'catchwords_basket#update'
  get 'catchword_basket/:basket_id/destroy', to: 'catchwords_basket#destroy', as: 'destroy_basket'

#########
# Admin #
#########

    get 'admin/verification/:token', to: 'dash_admin#verification', as: 'dash_admin_verfication'
    post 'admin/dash/teams/:team_id/generate_img_from_html', to: 'dash_admin#generate_img_from_html', as: 'dash_admin_generate_img_from_html'
    get 'admin/dash/games/:game_id/turns', to: 'dash_admin#turns', as: 'dash_admin_turns'
    
    get 'admin/dash/teams', to: 'dash_admin#teams', as: 'dash_admin_teams'
    get 'admin/dash/teams/:team_id/stats', to: 'dash_admin#team_stats', as: 'dash_admin_team_stats'
    get 'admin/dash/teams/:team_id/stats/share', to: 'dash_admin#team_stats_share', as: 'dash_admin_team_stats_share'
    get 'admin/dash/teams/:team_id/stats/:team2_id', to: 'dash_admin#team_stats', as: 'dash_admin_compare_team_stats'
    
    get 'admin/dash/users', to: 'dash_admin#users', as: 'dash_admin_users'
    get 'admin/dash/users/:team_id', to: 'dash_admin#users', as: 'dash_admin_team_users'
    post 'admins/dash/filter_videos', to:  'dash_admin#filter_videos', as: 'admin_filter_videos'
    get 'admins/dash/teams/:team_id/users/:user_id/stats', to: 'dash_admin#user_stats', as: 'dash_admin_user_stats'
    get 'admins/dash/stats/turns/:turn_id', to: 'dash_admin#turn_show', as: 'dash_admin_show_turn'
    delete 'admins/dash/stats/turns/:turn_id', to: 'dash_admin#delete_video', as: 'dash_admin_delete_video'
    get 'admins/teams/:team_id/users/:user_id/compare/:compare_user_id', to: 'dash_admin#compare_user_stats', as: 'dash_admin_compare_user_stats'
    get 'admins/dash/video_tool', to: 'dash_admin#video_tool', as: 'dash_admin_video_tool'
    get 'admins/dash/account', to: 'dash_admin#account', as: 'dash_admin_account'
    get 'admins/dash/billing', to: 'dash_admin#billing', as: 'dash_admin_billing'
    
    get 'admin/dash/', to: 'dash_admin#index', as: 'dash_admin'
    get 'admin/dash/catchwords', to: 'dash_admin#catchwords', as: 'dash_admin_catchwords'
    post 'admin/dash/catchwords/add', to: 'dash_admin#add_word', as: "dash_admin_add_word"
    post 'admin/dash/baskets', to: 'dash_admin#create_basket', as: "dash_admin_new_basket"
    post 'admin/dash/baskets/:basket_id', to: 'dash_admin#delete_basket', as: "dash_admin_delete_basket"
    delete 'admin/dash/catchwords/:word_id', to: 'dash_admin#remove_word', as: "dash_admin_remove_word"
    get 'admin/dash/:team_id', to: 'dash_admin#index', as: 'dash_admin_games'
    
############
# Sessions #
############


############
# User dashboard #
############



########
# Root #
########
    
  get 'root/login', to: 'root_session#new', as: 'login_root'
  post 'root/login', to: 'root_session#create'

  get 'root/logout', to: 'root_session#destroy', as: 'logout_root'

##################
# CRUD Ressource #
##################

#########
# Admin #
#########
    
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
  put 'users/:user_id/update', to: 'users#update', as: 'update_user'
  post 'users/create', to: 'users#create', as: 'create_user'

##########
# Rating #
##########
    
  get 'turns/:turn_id/ratings/new', to: 'ratings#new', as: 'new_rating'
  post 'turns/:turn_id/ratings/new', to: 'ratings#create'
    
  get 'turns/:turn_id/user/ratings/new', to: 'ratings#new_user', as: 'new_rating_user'
  post 'turns/:turn_id/user/ratings/new', to: 'ratings#create_user'
  post 'turns/:turn_id/comment', to: 'ratings#comment', as: 'create_comment'

########
# Word #
########
    
  get 'words/:basket_id/new', to: 'words#new', as: 'new_word'
  post 'words/:basket_id/new', to: 'words#create'

  get 'words/:basket_id/:word_id/edit', to: 'words#edit', as: 'edit_word'
  post 'words/:basket_id/:word_id/edit', to: 'words#update'
    
  get 'words/:basket_id/:word_id/destroy', to: 'words#destroy', as: 'destroy_word'
  mount ActionCable.server => '/cable'
    
##############
# Enter Game #
##############
  get '/team_list', to: 'dash_admin#get_teams'
  get '/words_list', to: 'dash_admin#get_words'
  post '/update_seconds', to: 'game_mobile_admin#update_game_seconds', as: 'gma_update_seconds'
  get 'mobile/admins/:password/password', to: 'game_mobile_admin#password', as: 'gma_pw'
  post 'mobile/admins/:password/password', to: 'game_mobile_admin#check_email', as: 'gma_email_check'
  post 'objection', to: 'game_desktop_admin#', as: 'gda_objection'
  get '/test', to: "dash_admin#testing_cam"

  get '/:password', to: 'game_mobile_user#welcome', as: 'gmu_start'

end
