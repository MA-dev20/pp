module DashAdminHelper


    def credit_card(admin)
        credit_card ="**** **** **** ****  #{admin.last_4_cards_digit}" 
        return credit_card
    end
end