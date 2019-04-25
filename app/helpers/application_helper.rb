module ApplicationHelper
	def create_image_of_html(html, js_path, css_path)
		kit = IMGKit.new(html, :quality => 50)
		kit.stylesheets << css_path
		kit.javascripts << js_path
		file = kit.to_file('file.jpg')
	end
end
