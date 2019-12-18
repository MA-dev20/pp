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

	def translate_video(video_path, wait_seconds)
		require "google/cloud/speech"
		require "google/cloud/storage"

		project_id = "clean-evening-261613"
		key_file   = "clean-evening-project-credentials.json"
		
		# Convert video to audio
		video_name = video_path.split('/').last.split('.mp4').first
		system "ffmpeg -i #{video_path} #{video_name}.flac"
		video_name_mono = video_name + '-mono'
		system "ffmpeg -i #{video_name}.flac -ac 1 #{video_name_mono}.flac"


		# Upload audio to Google Storage
		storage = Google::Cloud::Storage.new project: project_id, keyfile: key_file
		bucket_name = storage.buckets.first.name
		puts bucket_name
		bucket  = storage.bucket bucket_name
		file = bucket.create_file "#{video_name_mono}.flac", "#{video_name_mono}.flac"
		puts "Uploaded #{file.name}"
		File.delete("#{video_name_mono}.flac")
		File.delete("#{video_name}.flac")


		# Translate audio to text
		speech = Google::Cloud::Speech.new
		storage_path = "gs://audio_bucket-1/#{video_name_mono}.flac"
		config = { encoding: :FLAC,
				language_code: "de-DE" }
		audio = { uri: storage_path }
		operation = speech.long_running_recognize config, audio

		audio_text = ''
		puts "Operation started"
		if !operation.nil?
			operation.wait_until_done!
			raise operation.results.message if operation.error?
			results = operation.response.results
			results.each do |result|
				audio_text << result.alternatives.first.transcript
				puts "Transcription: #{result.alternatives.first.transcript}"
			end
		end

		if audio_text.present?
			# return words_count(audio_text)
			do_words_count = 0
			dont_words_count = 0
			do_words = ['hello', 'hallo']
			dont_words = ['friends', 'so']

			audio_text_array = audio_text.split()
			audio_text_array.map!(&:downcase)
			do_words.each do |word|
				do_words_count += audio_text_array.count(word.downcase)
			end
			dont_words.each do |word|
				dont_words_count += audio_text_array.count(word.downcase)
			end
			if wait_seconds == 80
				wpm = audio_text.length/1.34
			elsif wait_seconds == 150
				wpm = audio_text.length/2.5
			else
				wpm = audio_text.length/5
			end
			return audio_text, do_words_count, dont_words_count, wpm.round
		else
			return '', 0, 0, 0
		end
	end

	# def words_count(audio_text)
	# 	# Do words and Don't words count
	# 	do_words_count = 0
	# 	dont_words_count = 0
	# 	do_words = ['promotes', 'the']
	# 	dont_words = ['friends', 'so']

	# 	audio_text_array = audio_text.split()

	# 	do_words.each do |word|
	# 	  do_words_count += audio_text_array.count(word)
	# 	end

	# 	dont_words.each do |word|
	# 	  dont_words_count += audio_text_array.count(word)
	# 	end
	# 	return do_words_count, dont_words_count, 0
	# end

end