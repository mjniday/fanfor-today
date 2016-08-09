class PicksController < ApplicationController
	
	def new
	end

	def create
		@pick = get_active_matchweek.picks.new(pick_params.merge(:fixture_id => get_fixture_id(pick_params[:team_id])))
		if @pick.save
			redirect_back fallback_location: { action: "index" }
		else
			redirect_back fallback_location: { action: "index" }
		end
		Rails.logger.info(@pick.errors.inspect) 
	end

	def destroy
		Pick.find(params[:id]).destroy
		flash[:success] = "Pick removed"
		redirect_back fallback_location: { action: "index" }
	end

	private
	def pick_params
		params.require(:pick).permit(:team_id).merge(:user_id => current_user.id,:result_points => 0,:result_gd => 0)
	end

	def get_active_matchweek
		Matchweek.find_by(:status => :activated)
	end

	def get_fixture_id(team)
		get_active_matchweek.fixtures.where("home_team_id = ? OR away_team_id = ?", team, team).first.id
	end
end
