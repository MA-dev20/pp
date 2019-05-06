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
end
