class ObjectionsBasket < CatchwordsBasket
  belongs_to :admin, required: false
  belongs_to :game, required: false
  has_many :objection_basket_objections
  has_many :objections, through: :objection_basket_objections, class_name: 'Objection'
  default_scope { where(objection: true) }
  DEFAULT_OBJECTIONS = [
  	'Keine Zeit',
  	'Bei der Konkurrenz',
  	'Auf den Punkt kommen',
  	'Kein Budget', 
  	'Schick mir eine Mail',
  	'Kein Interesse',
  	'Muss ich den Chef Fragen',
  	'Referenzen',
  	'Ist Quatsch'
  ]

  def self.peter_objections
  	basket = includes(:objections).where(name: 'peter_objections').first
  	if !basket.present?
  		basket = new(name: 'peter_objections')
  		basket.save!
  	end
  	if basket.objections.count != DEFAULT_OBJECTIONS.length 
	  	DEFAULT_OBJECTIONS.each do |name|
	  		objection = basket.objections.find_by_name(name)
	  		if !objection.present?
		  		new_obj = Objection.new(name: name)
		  		new_obj.save! 
		  		basket.objections << new_obj
		  	end
		end
	end
	basket.objections
  end
end
