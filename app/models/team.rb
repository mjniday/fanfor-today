class Team < ApplicationRecord
	validates :external_id, uniqueness: true
end
