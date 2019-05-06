module Basket
  def has_or_create_basket_for_words
	  if self.catchword_basket.nil?
	    self.build_catchword_basket.save!
	  end
	  return self.catchword_basket
	end
end