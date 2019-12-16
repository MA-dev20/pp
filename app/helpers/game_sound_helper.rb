module GameSoundHelper
	
  def choose_sound
	r = Random.rand(1...11)
	if r == 1
	  return 'choose/2kandidaten.mp3'
	elsif r == 2
	  return 'choose/2woelfe.mp3'
	elsif r == 3
	  return 'choose/fingerauficons.mp3'
	elsif r == 4
	  return 'choose/handesmartphones.mp3'
	elsif r == 5
	  return 'choose/hatbegonnen.mp3'
	elsif r == 6
	  return 'choose/ichhabefavoriten.mp3'
	elsif r == 7
	  return 'choose/jetztabstimmen.mp3'
	elsif r == 8
	  return 'choose/tipptaufden.mp3'
	elsif r == 9
	  return 'choose/wahlehre.mp3'
	elsif r == 10
	  return 'choose/werpitcht.mp3'
	end
  end
	
  def ended_sound
	r = Random.rand(1...5)
	if r == 1
	  return 'ended/runde.mp3'
	elsif r == 2
	  return 'ended/trommelwirbel.mp3'
	elsif r == 3
	  return 'ended/vorne.mp3'
	elsif r == 4
	  return 'ended/ueberzeugt.mp3'
	end
  end
	
  def rate_sound
	r = Random.rand(1...4)
	if r == 1
	  return 'rate/haltemichraus.mp3'
	elsif r == 2
	  return 'rate/lehnezurueck.mp3'
	elsif r == 3
	  return 'rate/nichtschlecht.mp3'
	end
  end
	
  def rated_sound
	r = Random.rand(1...11)
	if r == 1
	  return 'rated/befoerderung.mp3'
	elsif r == 2
	  return 'rated/bingespannt.mp3'
	elsif r == 3
 	  return 'rated/gaensehaut.mp3'
	elsif r == 4
	  return 'rated/haettegekauft.mp3'
	elsif r == 5
	  return 'rated/ihrhabtbewertet.mp3'
	elsif r == 6
	  return 'rated/jaaaaa.mp3'
	elsif r == 7
	  return 'rated/neuerleitwolf.mp3'
	elsif r == 8
	  return 'rated/staunen.mp3'
	elsif r == 9
	  return 'rated/ueberzeugperformance.mp3'
	elsif r == 10
	  return 'rated/wolfowelpe.mp3'
	end
	  
  end
  def turn_sound
    r = Random.rand(1...7)
    if r == 1
      return 'turn/besonderescatchword.mp3'
	elsif r == 2
	  return 'turn/glaskugel.mp3'
	elsif r == 3
	  return 'turn/lettheshow.mp3'
	elsif r == 4
	  return 'turn/naechstevertriebsleiter.mp3'
	elsif r == 5
	  return 'turn/shakkaduschaffst.mp3'
	elsif r == 6
	  return 'turn/wow.mp3'
	end
  end
	
  def wait_sound
	r = Random.rand(1...5)
	if r == 1
	  return 'wait/aufgeregt.mp3'
	elsif r == 2
	  return 'wait/bereit.mp3'
	elsif r == 3
	  return 'wait/kommando.mp3'
	elsif r == 4
	  return 'wait/truppe.mp3'
	end
  end
end