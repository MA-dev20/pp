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

    def get_color_code(value)
        if value > 0 && value <= 50
            '#FF4233'
        elsif value > 50 && value < 80
            '#FFD733'
        else
            '#8DFF33'
        end
    end

end