module VideosHelper
	def json_convert(turns, sortby="time")
	  result = []
	  turns.each do |t|
	    if t.turn_rating.present? and t.recorded_pitch.present?
	      turn = JSON.parse(t.to_json(include: [:turn_rating]))
	      turn["rating"] = number_with_precision(t.turn_rating.slice("creative", "body","rhetoric", "spontan").values.map(&:to_f).inject(:+) / 40, precision: 1).to_f if t.turn_rating.present?          
	      turn["rating"] = number_with_precision(t.ratings.pluck('avg(body), avg(creative), avg(spontan), avg(rhetoric)').first.inject(:+).to_f  / 40, precision: 1).to_f if t.ratings.present?
	      turn["word"] = t.word.name if t.word.present?
	      turn["name"] = (t.user.fname.present? ? t.user.fname.to_s.capitalize : '') + ' ' + (t.user.lname.present? ? t.user.lname.first.upcase+"." : '')  if t.user.present?
	      turn["profile_pic"] = t.user.avatar.url if t.user.present?
	      turn["name"] = t.admin.fname.to_s.capitalize + ' ' + (t.admin.lname.present? ? t.admin.lname.first.upcase+"." : t.admin.lname) if t.admin.present? and !turn["name"].present?
	      turn["profile_pic"] = t.admin.avatar.url if !turn["profile_pic"].present?
	      turn["duration"] = t.recorded_pitch_duration.to_minutes if t.recorded_pitch_duration.present?
	      turn["time"] = t.created_at.strftime("%d.%m.%Y")
	      turn["recorded_pitch_url"] = t.recorded_pitch.thumb.url if t.recorded_pitch.present?
	      result.push(turn)
	    end
	  end
	  if (sortby=="date")
	    result.sort_by! { |hsh| hsh["created_at"].to_datetime }
	    result.reverse!
	  else
	    result.sort_by! { |hsh| hsh["rating"].to_f }
	    result.reverse!
	  end
	  result.each_slice(6)
	end

end