module Basket
  def has_or_create_basket_for_words
	  if self.catchword_baskets.nil?
	    self.catchword_baskets.build.save!
	  end
	  return self.catchword_baskets
	end

	def has_or_create_basket_for_words
	  if self.catchword_baskets.nil?
	    self.catchword_baskets.build.save!
	  end
	  return self.catchword_baskets
	end
end