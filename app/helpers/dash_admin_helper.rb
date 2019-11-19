module DashAdminHelper


    def credit_card(admin)
        credit_card ="**** **** **** ****  #{admin.last_4_cards_digit}" 
        return credit_card
    end


    def display_popup
        return @pending_count > 0 ? 'block;' : 'none;'
    end

    def display_modal
        return @count > 0 ? 'block;' : 'none;'
    end

end