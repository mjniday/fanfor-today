class FixturesController < ApplicationController
	def index
		if Matchweek.find_by(:status => :activated) == nil && Matchweek.find_by(:status => :locked) == nil
			@no_active_matchweek = "There are no active matchweeks. Check back later"
		elsif Matchweek.find_by(:status => :activated)
			@active_matchweek = Matchweek.find_by(:status => :activated)
			@current_pick = @active_matchweek.picks.find_by(:user_id => current_user.id)

			# Pick dropdown
			# All teams active in the current matchweek
			team_ids = @active_matchweek.fixtures.pluck(:home_team_id,:away_team_id).flatten
			all_teams = team_ids.map{|t| Team.find(t)}
			# remove teams I've picked in previous matchweeks
			picked_teams = current_user.picks.pluck(:team_id).map{|t| Team.find(t)}
			remaining_teams = all_teams - picked_teams
			@remaining_teams = remaining_teams.sort_by{|t| t[:name]}
		elsif Matchweek.find_by(:status => :locked)
			@locked_matchweek = Matchweek.find_by(:status => :locked)

			if @locked_matchweek.picks.find_by(:user_id => current_user)
				@locked_pick = Team.find(@locked_matchweek.picks.find_by(:user_id => current_user).team_id).name
			else
				@locked_pick = "You didn't make a selection this week"
			end
		else
			# ... not sure what might fall here
		end

		# Current fixture list
		if @active_matchweek
			@fixtures = @active_matchweek.fixtures
		elsif @locked_matchweek
			@fixtures = @locked_matchweek.fixtures
		else
			@fixtures = []
		end
				

		# My historical picks
		@picks = current_user.picks.all

		# League Standings
		@users = User.all
	end

	def new
		@matchweek = Matchweek.find(params[:matchweek_id])
		@fixture = @matchweek.fixtures.new
	end

	def create
		@matchweek = Matchweek.find(params[:matchweek_id])
		Rails.logger.info("Matchweek = #{@matchweek}")
		@fixture = @matchweek.fixtures.new(fixture_params)
		if @fixture.save
			redirect_to @matchweek
		else
			render 'edit'
			Rails.logger.info(@fixture.errors.inspect) 
		end
	end

	def edit
		@matchweek = Matchweek.find(params[:matchweek_id])
		@fixture = @matchweek.fixtures.find(params[:id])
	end

	def update
		@matchweek = Matchweek.find(params[:matchweek_id])
	    @fixture = @matchweek.fixtures.find(params[:id])
	    if @fixture.update_attributes(fixture_params)
	    	flash[:success] = "Fixture updated"
      		redirect_to @matchweek
	    else
	     	render 'edit'
    	end
  	end

  	private
  	def fixture_params
  		params.require(:fixture).permit(:home_team_id,:home_team_score,:away_team_score,:away_team_id,:matchweek_id,:external_id)
  	end
end
