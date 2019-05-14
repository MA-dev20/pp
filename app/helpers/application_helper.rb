module ApplicationHelper
	def create_image_of_html(html, js_path, css_path)
		kit = IMGKit.new(html, :quality => 50)
		kit.stylesheets << css_path
		kit.javascripts << js_path
		file = kit.to_file('file.jpg')
	end

	def send_invitation_emails_to_team_members(team, game)
		team.users.each do |user|
			SendEmailJob.perform_later(user, game)
		end
	end

	def get_current_user_position(result)
		@show_three = {}
    result.each.with_index do |r,i|
      if r.present?
        if r[:user].id.to_s == params[:user_id]
          @key = i
          break
     		end
      end
    end
    if result.length-1 == @key && result.length ==1
      @show_three[@key] = result[@key]
    elsif result.length-1 == @key 
      @show_three[@key - 2] = result[@key -2]
      @show_three[@key - 1] = result[@key -1]
      @show_three[@key] = result[@key]
    elsif @key == 0
      @show_three[@key] = result[@key]
      @show_three[@key+1] = result[@key+1]
      @show_three[@key+2] = result[@key+2]
    else
      @show_three[@key -1] = result[@key-1]
      @show_three[@key] = result[@key]
      @show_three[@key+1] = result[@key+1]
    end
    return @show_three
	end
end
