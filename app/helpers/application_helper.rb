module ApplicationHelper
  include VideosHelper
	def create_image_of_html(html, js_path, css_path)
		kit = IMGKit.new(html, :quality => 50)
		kit.stylesheets << css_path
		kit.javascripts << js_path
		file = kit.to_file('file.jpg')
	end

  
  def random_pass
    (0...8).map { (65 + rand(26)).chr }.join
  end


	def send_invitation_emails_to_team_members(team, game)
		team.users.each do |user|
			SendEmailJob.perform_later(user, game)
		end
	end

	def get_current_user_position(result, id)
		@show_three = {}
    result.each.with_index do |r,i|
      if r.present?
        if r[:user].id.to_s == id.to_s
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
  
  def generate_qr(text)
    require 'barby'
    require 'rqrcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/svg_outputter'
    require 'barby/outputter/cairo_outputter'

    qr = Barby::QrCode.new(text, level: :q, size: 15)
    svg = Barby::CairoOutputter.new(qr).to_svg({ xdim: 5, margin: 0 })
    svg.sub!('<svg ', '<svg preserveAspectRatio="none" ')
    svg.sub!('rgb(100%,100%,100%)', 'white')
    svg.sub!('rgb(0%,0%,0%)', 'rgb(20, 93, 170)')
    svg.sub!('385', '200')
    svg.sub!('385', '200')
    "data:image/svg+xml;utf8,#{svg.gsub(/\n/, '')}"
  end
end
