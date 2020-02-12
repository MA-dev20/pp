Rails.application.routes.draw do
  devise_for :games
  devise_for :users
  devise_for :admins, controllers: { registrations: 'admins/registrations', sessions: 'admins/sessions', passwords: 'admins/passwords', confirmations: 'admins/confirmations', unlocks: 'admins/unlocks'}
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
 
###########
# Landing #
###########
  root 'landing#index'
  get 'admins/:admin_id/confirm', to: "landing#after_confirm", as: 'admin_after_confirm'
  get 'cookies', to: 'landing#accept_cookies', as: 'accept_cookies'
  get '/contact', to: 'landing#contact', as: 'contact'
  get 'datenschutz', to: 'landing#datenschutz', as: 'datenschutz'
  get 'impressum', to: 'landing#impressum', as: 'impressum'
	
  get 'landing/ended_game', to: 'landing#ended_game', as: 'landing_ended_game'

  get '/byebye', to: 'landing#byebye', as: 'byebye'
  # patch 'verification/verify_token' ,to: 'verification#verify_token' , as:'verify_token'
  get 'admins/register', to: 'landing#register', as: 'register'
  get 'admins/signup/:v_id', to: 'landing#signup' , as: 'edit_next_admin'
  patch 'admins/update_admin/:v_id', to: 'landing#update_admin', as: 'update_admin'
  patch 'admins/update_admin_details/:v_id', to: 'landing#update_admin_details', as: 'update_admin_details'

  get 'coaches/info', to: 'landing#coach', as: 'coach_info'
  # get '/verfication/:token' , to: 'verification#token' , as: 'verification_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
########
# Game #
########

#################
# Admin Desktop #
#################

  get 'games/wait', to: 'game_desktop_admin#wait', as: 'gda_wait'
  get 'games/intro', to: 'game_desktop_admin#intro', as: 'gda_intro'
  get 'games/youtube_video', to: 'game_desktop_admin#youtube_video', as: 'gda_youtube'
  get 'games/choose', to: 'game_desktop_admin#choose', as: 'gda_choose'
  get 'games/turn', to: 'game_desktop_admin#turn', as: 'gda_turn'
  get 'games/error', to: 'game_desktop_admin#error', as: 'gea_turn'
  get 'video_testing', to: 'game_mobile_admin#video_testing'
  get 'games/play', to: 'game_desktop_admin#play', as: 'gda_play'
  get 'games/rate', to: 'game_desktop_admin#rate', as: 'gda_rate'
  get 'games/rating', to: 'game_desktop_admin#rating', as: 'gda_rating'
  get 'games/bestlist', to: 'game_desktop_admin#bestlist', as: 'gda_bestlist'
  get 'games/ended', to: 'game_desktop_admin#ended', as: 'gda_ended'
  get 'games/ended_game', to: 'game_desktop_admin#ended_game', as: 'gda_ended_game'
  get 'games/replay', to: 'game_desktop_admin#replay', as: 'gda_replay'
    
  get 'games/after_rating', to: 'game_desktop_admin#after_rating', as: 'gda_after_rating'
  get 'games/video_uploaded_status', to: 'game_desktop_admin#video_uploaded_status', as: 'gda_video_uploaded_status'
  

################
# Admin Mobile #
################

  
  get 'mobile/admins/:password', to: 'game_mobile_admin#new', as: 'gma_start'
  post 'mobile/admins/:password', to: 'game_mobile_admin#create'
  get 'mobile/admin/avatar', to: 'game_mobile_admin#new_avatar', as: 'gma_new_avatar'
  post 'mobile/admin/avatar', to: 'game_mobile_admin#create_avatar'
  get 'mobile/admin/new_turn', to: 'game_mobile_admin#new_turn', as: 'gma_new_turn'
  post 'mobile/admin/new_turn', to: 'game_mobile_admin#create_turn'
    
  get 'mobile/admin/wait', to: 'game_mobile_admin#wait', as: 'gma_wait'
  get 'mobile/admin/intro', to: 'game_mobile_admin#intro', as: 'gma_intro'
  get 'mobile/admin/youtube_video', to: 'game_mobile_admin#youtube_video', as: 'gma_youtube'
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
  get 'mobile/admin/ended_game', to: 'game_mobile_admin#ended_game', as: 'gma_ended_game'
  get 'mobile/admin/after_rating', to: 'game_mobile_admin#after_rating', as: 'gma_after_rating'
  post 'mobile/admin/update_video_status', to: 'game_mobile_admin#update_video_status', as: 'gma_update_video_status'

    
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
  get 'mobile/user/game/intro', to: 'game_mobile_user#intro', as: 'gmu_intro'
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
  get 'mobile/user/game/ended_game', to: 'game_mobile_user#ended_game', as: 'gmu_ended_game'
	
############
# Vertrieb #
############
	
  get '/vertrieb', to: 'vertrieb#new', as: 'vertrieb'
  post 'vertrieb/new', to: 'vertrieb#create', as: 'new_vertrieb'
  post 'vertrieb/login', to: 'vertrieb#login', as: 'login_vertrieb'
 
  get 'vertrieb/start', to: 'vertrieb#start', as: 'start_vertrieb'
  get 'vertrieb/proceed', to: 'vertrieb#proceed', as: 'proceed_vertrieb'
	
  get "vertrieb/game_wait", to: "vertrieb#game_wait", as: 'game_wait_vertrieb'
  get 'vertrieb/game_choose', to: 'vertrieb#game_choose', as: 'game_choose_vertrieb'
  get 'vertrieb/game_turn', to: 'vertrieb#game_turn', as: 'game_turn_vertrieb'
  get 'vertrieb/game_play', to: 'vertrieb#game_play', as: 'game_play_vertrieb'
  get 'vertrieb/game_rate', to: 'vertrieb#game_rate', as: 'game_rate_vertrieb'
  get 'vertrieb/game_rated', to: "vertrieb#game_rated", as: 'game_rated_vertrieb'
  get 'vertrieb/game_bestlist', to: 'vertrieb#game_bestlist', as: 'game_bestlist_vertrieb'
	
  get 'vertrieb/dash_customize', to: 'vertrieb#dash_customize', as: 'dash_customize_vertrieb'
  get 'vertrieb/dash_lets_pitch', to: 'vertrieb#dash_lets_pitch', as: 'dash_lets_pitch_vertrieb'
  get 'vertrieb/dash_lets_pitch2', to: 'vertrieb#dash_lets_pitch2', as: 'dash_lets_pitch2_vertrieb'
  get 'vertrieb/dash_user_stats', to: 'vertrieb#dash_user_stats', as: 'dash_user_stats_vertrieb'
  get 'vertrieb/dash_users', to: 'vertrieb#dash_users', as: 'dash_users_vertrieb'
  get 'vertrieb/dash_videoanalyse', to: 'vertrieb#dash_videoanalyse', as: 'dash_videoanalyse_vertrieb'
	
  get 'vertrieb/ended', to: 'vertrieb#ended', as: 'ended_vertrieb'
    
####################################################################################
#############
# Dashboard #
#############

##############
# Backoffice #
##############
  
  get 'backoffice', to: 'backoffice#index', as: 'backoffice'
	
  get 'backoffice/admins', to: 'backoffice#admins', as: 'backoffice_admins'
  get 'backoffice/admins/:admin_id', to: 'backoffice#admin', as: 'backoffice_admin'
  get 'backoffice/admins/:admin_id/teams', to: 'backoffice#teams', as: 'backoffice_teams'
  get 'backoffice/admins/:admin_id/teams/:team_id', to: 'backoffice#team', as: 'backoffice_team'
  get 'backoffice/admins/:admin_id/users', to: 'backoffice#users', as: 'backoffice_users'
  get 'backoffice/admins/:admin_id/users/:user_id', to: 'backoffice#user', as: 'backoffice_user'
  get 'backoffice/admins/:admin_id/games', to: 'backoffice#games', as: 'backoffice_games'
  get 'backoffice/admins/:admin_id/games/:game_id', to: 'backoffice#game', as: 'backoffice_game'
  get 'backoffice/admins/:admin_id/words', to: 'backoffice#words', as: 'backoffice_words'
  get 'backoffice/admins/:admin_id/words/:basket_id', to: 'backoffice#word', as: 'backoffice_word'
  get 'backoffice/words', to: 'backoffice#words', as: 'backoffice_words_noadmin'
  get 'backoffice/words/:basket_id', to: 'backoffice#word', as: 'backoffice_word_noadmin'
  get 'backoffice/admins/:admin_id/objections', to: 'backoffice#objections', as: 'backoffice_objections'
  get 'backoffice/admins/:admin_id/objections/:basket_id', to: 'backoffice#objection', as: 'backoffice_objection'
  get 'backoffice/objections', to: 'backoffice#objections', as: 'backoffice_objections_noadmin'
  get 'backoffice/objections/:basket_id', to: 'backoffice#objection', as: 'backoffice_objection_noadmin'
	
  get 'backoffice/roots', to: 'backoffice#roots', as: 'backoffice_roots'
  get 'backoffice/roots/:root_id', to: 'backoffice#root', as: 'backoffice_root'
  get 'backoffice/sales', to: 'backoffice#sales', as: 'backoffice_sales'
  get 'backoffice/sales/:vertrieb_id/sale_pictures', to: 'backoffice#sale_pictures', as: 'backoffice_sale_pictures'
  get 'backoffice/blogs', to: 'backoffice#blogs', as: 'backoffice_blogs'
  get 'backoffice/blogs/:blog_id', to: 'backoffice#blog', as: 'backoffice_blog'
  ##############
  # CRUD Admin #
  ##############
  post 'backoffice/admins/new', to: 'backoffice#new_admin', as: 'backoffice_new_admin'
  get 'backoffice/admins/:admin_id/activate', to: 'backoffice#activate_admin', as: 'backoffice_activate_admin'
  post 'backoffice/admins/:admin_id/edit', to: 'backoffice#edit_admin', as: 'backoffice_edit_admin'
  put 'backoffice/admins/:admin_id/update_avatar', to: 'backoffice#update_admin_avatar', as: 'backoffice_update_admin_avatar'
  put 'backoffice/admins/:admin_id/update_logo', to: 'backoffice#update_admin_logo', as: 'backoffice_update_admin_logo'
  get 'backoffice/admins/:admin_id/destroy', to: 'backoffice#destroy_admin', as: 'backoffice_destroy_admin'
  #############
  # CRUD Team #
  #############
  post 'backoffice/admins/:admin_id/teams/new', to: 'backoffice#new_team', as: 'backoffice_new_team'
  post 'backoffice/teams/:team_id/edit', to: 'backoffice#edit_team', as: 'backoffice_edit_team'
  get 'backoffice/teams/:team_id/destroy', to: 'backoffice#destroy_team', as: "backoffice_destroy_team"
  #############
  # CRUD User #
  #############
  post 'backoffice/admins/:admin_id/users/new', to: 'backoffice#new_user', as: 'backoffice_new_user'
  post 'backoffice/users/:user_id/edit', to: 'backoffice#edit_user', as: 'backoffice_edit_user'
  put 'backoffice/users/:user_id/update_avatar', to: 'backoffice#update_user_avatar', as: 'backoffice_update_user_avatar'
  get 'backoffice/users/:user_id/destroy', to: 'backoffice#destroy_user', as: 'backoffice_destroy_user'
  #############
  # CRUD Game #
  #############
  post 'backoffice/games/new',to: 'backoffice#new_game', as: 'backoffice_new_game'
  post 'backoffice/games/:game_id/edit',to: 'backoffice#edit_game', as: 'backoffice_edit_game'
  get 'backoffice/games/:game_id/destroy',to: 'backoffice#destroy_game', as: 'backoffice_destroy_game'
  #############
  # CRUD Turn #
  #############
  get 'backoffice/turns/:turn_id/destroy', to: "backoffice#destroy_turn", as: "backoffice_destroy_turn"
  ###############
  # CRUD Rating #
  ###############
  post 'ratings/:turn_id/edit', to: 'backoffice#update_rating', as: 'backoffice_edit_rating'
  #############
  # CRUD ROOT #
  #############
  post 'backoffice/roots/new', to: 'backoffice#new_root', as: 'backoffice_new_root'
  post 'backoffice/roots/:root_id/edit', to: 'backoffice#edit_root', as: 'backoffice_edit_root'
  put 'backoffice/roots/:root_id/update_avatar', to: "backoffice#update_root_avatar", as: "backoffice_update_root_avatar"
  get 'backoffice/roots/:root_id/destroy', to: 'backoffice#destroy_root', as: 'backoffice_destroy_root'
  #################
  # CRUD Vertrieb #
  #################
  put 'backoffice/sales/:vertrieb_id/update_avatar', to: 'backoffice#update_vertrieb_avatar', as: 'update_vertrieb_avatar'
  put 'backoffice/sales/:vertrieb_id/update_logo', to: 'backoffice#update_vertrieb_logo', as: 'update_vertrieb_logo'
  #############
  # CRUD Blog #
  #############
  post 'backoffice/blogs/new', to: 'backoffice#new_blog', as: "backoffice_new_blog"
  post 'backoffice/blogs/:blog_id/edit', to: 'backoffice#edit_blog', as: "backoffice_edit_blog"
  get 'backoffice/blogs/:blog_id/destroy', to: 'backoffice#destroy_blog', as: 'backoffice_destroy_blog'

#########
# Admin #
#########

    get 'admin/verification/:token', to: 'dash_admin#verification', as: 'dash_admin_verfication'
    post 'admin/dash/teams/:team_id/generate_img_from_html', to: 'dash_admin#generate_img_from_html', as: 'dash_admin_generate_img_from_html'
    get 'admin/dash/games/:game_id/turns', to: 'dash_admin#turns', as: 'dash_admin_turns'
    
    #User
    get 'admin/dash/teams', to: 'dash_admin#teams', as: 'dash_admin_teams'
    get 'admin/dash/teams/:team_id', to: 'dash_admin#teams', as: 'dash_admin_team'
    get 'admin/dash/users/:user_id', to: 'dash_admin#teams', as: 'dash_admin_user'
    
    #Stats
    get 'admin/dash/users/:user_id/stats', to: 'dash_admin#user_stats', as: 'dash_admin_user_stats'
    get 'admin/dash/users/:user_id/stats/compare/:user2_id', to: 'dash_admin#user_stats_compare', as: 'dash_admin_user_stats_compare'
    get 'admin/dash/teams/:team_id/users/:user_id/stats', to: 'dash_admin#user_stats', as: 'dash_admin_team_user_stats'
    
    #Customize
    get 'admin/dash/customize', to: 'dash_admin#customize', as: 'dash_admin_customize'
    get 'admin/dash/customize/catchwords/:cbasket_id', to: 'dash_admin#customize', as: 'dash_admin_catchwords'
    get 'admin/dash/customize/objections/:obasket_id', to: 'dash_admin#customize', as: 'dash_admin_objections'
	post 'admin/dash/do_words', to: 'dash_admin#create_do_words', as: 'do_words'
	get 'admin/dash/do_words/:word/delete', to: 'dash_admin#destroy_do_word', as: "delete_do_word"
	get 'admin/dash/dont_words/:word/delete', to: 'dash_admin#destroy_dont_word', as: "delete_dont_word"
    #Video Tool
    get 'admins/dash/video_tool', to: 'dash_admin#video_tool', as: 'dash_admin_video_tool'
    get 'admins/dash/turns/:turn_id/video', to: 'dash_admin#video_details', as: 'dash_admin_video_details'
    
    post 'admins/dash/add_favorite', to: 'dash_admin#add_favorite', as: 'dash_admin_add_favorite'
    post 'admins/dash/remove_favorite', to: 'dash_admin#remove_favorite', as: 'dash_admin_remove_favorite'
    #Let's Play
    get 'admin/dash/', to: 'dash_admin#index', as: 'dash_admin'
    get 'admin/dash/:team_id', to: 'dash_admin#index', as: 'dash_admin_game'
	get 'admin/dash/games/:game_id/team/:team_id', to: 'dash_admin#index', as: 'dash_admin_game_2'
	get 'admin/dash/games/:game_id', to: 'dash_admin#index', as: 'dash_admin_create_game_2'
    
    #add video
    get 'admin/dash/turns/:turn_id/video/new', to: 'dash_admin#add_video_to_turn', as: 'add_video_to_turn'
    post 'admin/dash/turns/:turn_id/video/new', to: 'dash_admin#save_video_to_turn'
	
	#edit video
	get 'admin/dash/videos/:video_id/edit', to: 'dash_admin#video_edit', as: 'dash_admin_video_edit'
	get 'admin/dash/turns/:turn_id/video/destroy', to: "dash_admin#delete_pitch", as: 'dash_admin_delete_pitch'
    
    
    get 'admin/dash/statistics', to: 'dash_admin#statistics', as: 'dash_admin_statistics'
    get 'admin/dash/statistics/compare_with_team/:team_id', to: 'dash_admin#compare_with_team', as: 'dash_admin_comapre_with_team'
    get 'admin/dash/statistics/compare_with_user/:compare_user_id', to: 'dash_admin#compare_with_user', as: 'dash_admin_comapre_with_user'
    get 'admin/dash/teams/:team_id/stats', to: 'dash_admin#team_stats', as: 'dash_admin_team_stats'
    get 'admin/dash/teams/:team_id/stats/share', to: 'dash_admin#team_stats_share', as: 'dash_admin_team_stats_share'
    get 'admin/dash/teams/:team_id/stats/:team2_id', to: 'dash_admin#team_stats', as: 'dash_admin_compare_team_stats'
    
    
    get 'admin/dash/user_list', to: 'dash_admin#user_list', as: 'dash_admin_user_list'
    get 'admin/dash/users/:team_id', to: 'dash_admin#users', as: 'dash_admin_team_users'
    post 'admins/dash/filter_videos', to:  'dash_admin#filter_videos', as: 'admin_filter_videos'
    get 'admins/dash/stats/turns/:turn_id', to: 'dash_admin#turn_show', as: 'dash_admin_show_turn'
    delete 'admins/dash/stats/turns/:turn_id', to: 'dash_admin#delete_video', as: 'dash_admin_delete_video'
    get 'admins/teams/:team_id/users/:user_id/compare/:compare_user_id', to: 'dash_admin#compare_user_stats', as: 'dash_admin_compare_user_stats'
    
    get 'admins/dash/account', to: 'dash_admin#account', as: 'dash_admin_account'
    get 'admins/dash/billing', to: 'dash_admin#billing', as: 'dash_admin_billing'
    
    
    post 'admin/dash/catchwords/add', to: 'dash_admin#add_word', as: "dash_admin_add_word"
    post 'admin/dash/objections/add', to: 'dash_admin#add_objection', as: "dash_admin_add_objection"
    put 'admin/dash/objections/:id', to: 'dash_admin#update_objection', as: "dash_admin_update_objection"
    put 'admin/dash/words/:id', to: 'dash_admin#update_word', as: "dash_admin_update_word"
	put 'admin/dash/logo/update', to: 'dash_admin#update_logo', as: 'update_logo'
	put 'admin/dash/avatar/update', to: 'dash_admin#update_avatar', as: 'update_avatar'
    post 'admin/dash/baskets', to: 'dash_admin#create_basket', as: "dash_admin_new_basket"
    post 'admin/dash/baskets/:basket_id', to: 'dash_admin#delete_basket', as: "dash_admin_delete_basket"
    post 'admin/dash/objections/:basket_id', to: 'dash_admin#delete_objection_basket', as: "dash_admin_delete_objection_basket"
    delete 'admin/dash/catchwords/:word_id', to: 'dash_admin#remove_word', as: "dash_admin_remove_word"
    delete 'admin/dash/objections/:word_id', to: 'dash_admin#remove_objection', as: "dash_admin_remove_objection"
    get 'admin/dash/:team_id', to: 'dash_admin#index', as: 'dash_admin_games'
    post 'admin/dash/turn/:turn_id/release_comments', to: 'dash_admin#release_comments', as: 'dash_admin_release_comments'
############
# Sessions #
############

# Admin #

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
    
  post 'admins/new', to: 'admins#create', as: 'new_admin'
  post 'admins/:admin_id/edit', to: 'admins#update', as: 'edit_admin'
  post 'admins/:admin_id/activate', to: 'admins#activate', as: 'activate_admin'
  post 'admins/:admin_id/avatar/edit', to: 'admins#update_avatar', as: 'edit_admin_avatar'
  post 'admins/:admin_id/logo/edit', to: 'admins#update_logo', as: 'edit_admin_logo'
  get 'admins/:admin_id/destroy', to: 'admins#destroy', as: 'destroy_admin'

########
# Team #
########
    
  post 'teams/new', to: 'teams#create', as: 'new_team'
  post 'teams/:team_id/edit', to: 'teams#update', as: 'edit_team'  
  get 'teams/:team_id/destroy', to: 'teams#destroy', as: 'destroy_team'

########
# Game #
########
    
  get 'games/new', to: 'games#new', as: 'new_game'
  post 'games/new', to: 'games#create'
  post 'games/:game_id/new', to: 'games#create_2', as: 'new_game_2'
  post 'games/:game_id/update', to: 'games#update', as: 'update_game'
  get 'games/:game_id/destroy', to: 'games#destroy', as: 'destroy_game'

########
# User #
########
    
  post 'users/new', to: 'users#create', as: 'new_user'
  post 'user/:user_id/edit', to: 'users#update', as: 'edit_user'
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

  post 'words/:basket_id/new', to: 'words#create', as: "new_word"

  post 'words/:basket_id/:word_id/edit', to: 'words#update', as: 'edit_word'
    
  get 'words/:basket_id/:word_id/destroy', to: 'words#destroy', as: 'destroy_word'
  mount ActionCable.server => '/cable'

#########
# Video #
#########
    
  get 'videos/new', to: 'videos#new', as: 'video_upload'
  post 'videos/new', to: 'videos#create'
  post 'videos/:video_id/edit', to: 'videos#update', as: 'edit_video'
  get 'videos/:video_id/destroy', to: 'videos#destroy', as: 'destroy_video'
    
###########
# Comment #
###########
    
  get 'turns/:turn_id/comments/new', to: 'comments#new', as: 'new_comment'
  post 'turns/:turn_id/comments/new', to: 'comments#create'
  get 'comments/:comment_id/destroy', to: 'comments#destroy', as: 'destroy_comment'
  post "comments/:comment_id/edit", to: 'comments#update', as: 'edit_comment'
#############
# Objection #
#############

  post 'objections/:basket_id/new', to: 'objections#create', as: 'new_objection'
  post 'objections/:basket_id/:objection_id/edit', to: 'objections#update', as: 'edit_objection'
  get "baskets/:basket_id/objections/:objection_id", to: "objections#destroy", as: 'destroy_objection'
  
##########
# Basket #
##########
    
  post 'basket/new', to: 'basket#create', as: 'new_basket'
  post 'basket/:basket_id/edit', to: 'basket#update', as: 'edit_basket'
  get 'basket/:basket_id/destroy', to: 'basket#destroy', as: 'destroy_basket'
    
##############
# Enter Game #
##############
  get '/team_list', to: 'dash_admin#get_teams'
  get '/words_list', to: 'dash_admin#get_words'
  get '/objections_list', to: 'dash_admin#get_objections'
  post '/update_seconds', to: 'game_mobile_admin#update_game_seconds', as: 'gma_update_seconds'
  get 'mobile/admins/:password/password', to: 'game_mobile_admin#password', as: 'gma_pw'
  post 'mobile/admins/:password/password', to: 'game_mobile_admin#check_email', as: 'gma_email_check'
  post 'objection', to: 'game_desktop_admin#', as: 'gda_objection'
  get '/test', to: "dash_admin#testing_cam"

  get '/:password', to: 'game_mobile_user#welcome', as: 'gmu_start'

end

