class Cost < ApplicationRecord
	validates :cost_name, presence: true
	validates :user_id, presence: true
	validates :amount, presence: true
	default_scope {order('id DESC')}
	# def self.list_costs
 #  		cost_list = []
 #  		costs = Cost.all
 #  		costs.each do |cost|
 #    		cost_info = cost.attributes
 #    		cost_info[:user_name] = User.find(cost.user_id).name
 #    		cost_list << cost_info
 #  		end
 #  		cost_list
	# end
end
