class UsersDatatable
  delegate :params, :h,:content_for, :render,:link_to, :span, :current_admin,:content_tag,:image_tag, :number_to_currency,:dash_admin_user_stats_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: current_admin.users.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      a=[	
      	(user.avatar.url.present? ? image_tag(user.avatar.quad.url) : image_tag('defaults/wolf.jpg')),
        (user.fname.to_s+ " "+user.lname.to_s),
        user.email,
        user.company_name,
       ] 
	 		Turn.where(user_id: user.id).last.present? ? a.push(Turn.where(user_id: user.id).last.updated_at.strftime('%d.%m.%Y')) : a.push(nil)
			a.push(user.turns.count)
			a.push({button: link_to( 'Edit','#',  class: 'edit-user', :data => { :id => user.id, user: user.to_json, teams: user.teams.to_json }), edit_partial: '', del_partial: ''})
			a.push(link_to('',dash_admin_user_stats_path("1", user), class: 'fas fa-chart-line package_pop_up'))
    end
  end

  def users
    @users ||= fetch_users
  end

  def sort_column
    columns = %w[avatar fname email company_name last_play]

    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

  def fetch_users
  	if params[:team_id].present?
  		users = Team.find(params[:team_id]).users.order("#{sort_column} #{sort_direction}")
  	else
  		users = current_admin.users.order("#{sort_column} #{sort_direction}")
  	end
    users = users.page(page).per_page(per_page)
    if params[:search][:value].present?
      users = users.where("fname like :search or email like :search or company_name like :search", search: "%#{params[:search][:value]}%")
    end
    users
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

end