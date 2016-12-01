class LeaguesController < ApplicationController
  def index
    @leagues = current_user.leagues.all
  end

  def show
    if current_user.leagues.include?(League.find(params[:id]))
      @league = League.find(params[:id])
      if Matchweek.find_by(:status => :activated) == nil && Matchweek.find_by(:status => :locked) == nil
        @no_active_matchweek = "There are no active matchweeks. Check back later"
      elsif Matchweek.find_by(:status => :activated)
        @active_matchweek = Matchweek.find_by(:status => :activated)
        # @current_pick = @league.picks.find_by(:user_id => current_user.id)
        @current_pick = current_user.picks.where("league_id = ? AND matchweek_id = ?",@league.id,@active_matchweek.id).first

        # Pick dropdown
        # All teams active in the current matchweek
        team_ids = @active_matchweek.fixtures.pluck(:home_team_id,:away_team_id).flatten
        all_teams = team_ids.map{|t| Team.find(t)}
        # remove teams I've picked in previous matchweeks
        picked_teams = @league.picks.where(:user_id => current_user.id).pluck(:team_id).map{|t| Team.find(t)}
        remaining_teams = all_teams - picked_teams
        @remaining_teams = remaining_teams.sort_by{|t| t[:name]}
      elsif Matchweek.find_by(:status => :locked)
        @locked_matchweek = Matchweek.find_by(:status => :locked)

        if current_user.picks.where("league_id = ? AND matchweek_id = ?", @league.id, @locked_matchweek.id).first
          @locked_pick = Team.find(current_user.picks.where("league_id = ? AND matchweek_id = ?", @league.id, @locked_matchweek.id).first.team_id).name
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
      @picks = @league.picks.where(:user_id => current_user)

      # League Standings
      @users = get_player_standings.sort_by {|user| [-user[:result_points],-user[:result_gd]]}
    end

    # League Table
    @table = get_league_table
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      @league.users << current_user
      redirect_to @league
    else
      render 'new'
    end
  end

  def invite_user
    email = params[:user][:email]
    new_user = User.invite!(:email => email)
    @league = League.find(params[:id])
    @league.users << new_user
    redirect_to @league
  end

  private
  def league_params
    params.require(:league).permit(:name)
  end

  def get_player_standings
    league = League.find(params[:id])
    users = []
    league.users.each do |u|
      user_username = u.username
      user_email = u.email
      user_points = league.picks.where(:user_id => u.id).pluck(:result_points).sum
      user_gd = league.picks.where(:user_id => u.id).pluck(:result_gd).sum
      users.push({:username => user_username, :email => user_email, :result_points => user_points, :result_gd => user_gd})
    end
    users
  end

  def get_league_table
    url = "http://api.football-data.org/v1/competitions/426/leagueTable"
    response = HTTParty.get(url,:headers => {"X-Auth-Token" => ENV['football_data']}).parsed_response
    response['standing']
  end
end
