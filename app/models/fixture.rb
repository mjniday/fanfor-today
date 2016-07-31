class Fixture < ApplicationRecord
	before_save :update_scores
	# before_save :calculate_results
	has_many :picks
	belongs_to :matchweek
	validates_uniqueness_of :external_id, :allow_nil => true

	private
	def update_scores
		if self.home_team_score != nil && self.away_team_score != nil
			if self.home_team_score > self.away_team_score
				self.winner_id = self.home_team_id
			elsif self.away_team_score > self.home_team_score
				self.winner_id = self.away_team_id
			else
				self.winner_id = 0
			end
			calculate_results
		end
	end

	def calculate_results
		# Get all the picks where ppl had skin in the game for this fixture
		picks = self.picks
		# Update the pts total and goal diff of those teams
		picks.each do |p|
			# p.team_id = Team selected to win the game
			if self.winner_id == p.team_id
				# The player correctly chose the winner
				p.result_points = 3
				if self.winner_id == self.home_team_id
					# Home team won
					p.result_gd = self.home_team_score - self.away_team_score
				else
					# Away team won
					p.result_gd = self.away_team_score - self.home_team_score
				end
			elsif self.winner_id == 0
				p.result_points = 1
				p.result_gd = 0
			else
				# The player chose incorrectly
				p.result_points = 0
				if self.winner_id == self.home_team_id
					# Home team won
					p.result_gd =  self.away_team_score - self.home_team_score
				else
					# Away team won
					p.result_gd =  self.home_team_score - self.away_team_score
				end
			end
			p.save
		end
	end
end
