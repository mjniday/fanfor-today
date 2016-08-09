class Pick < ApplicationRecord
	belongs_to :league
	belongs_to :user
	belongs_to :team
	belongs_to :fixture
	belongs_to :matchweek
	validates :user_id, :uniqueness => {:scope => [:matchweek_id,:league_id], :message => "One pick per user each matchweek"}
end
