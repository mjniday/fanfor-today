class LeaguesController < ApplicationController
  LEAGUE_TABLE_URL = "http://api.football-data.org/v1/competitions/426/leagueTable".freeze

  def index
    @leagues = current_user.leagues.all
  end

  def show
    return unless current_user.leagues.include?(league)

    if Matchweek.activated.empty?
      @no_active_matchweek = "There are no active matches. Check back later."

    elsif Matchweek.activated.present?
      @active_matchweek = get_active_matchweek

      unless @active_matchweek.locked?
        @current_pick = pick_for_matchweek(@active_matchweek.id)

        team_ids = @active_matchweek.fixtures.pluck(:home_team_id,:away_team_id).flatten
        all_teams = team_ids.map{|team_id| Team.find(team_id)}
        picked_teams = @league.picks.where(:user_id => current_user.id).pluck(:team_id).map{|t| Team.find(t)}
        remaining_teams = all_teams - picked_teams
        @remaining_teams = remaining_teams.sort_by{|team| team[:name]}

      else
        @locked_matchweek = get_active_matchweek
        if pick_for_matchweek(@locked_matchweek.id)
          @locked_pick = Team.find(pick_for_matchweek(@active_matchweek.id).team_id).name
        else
          @locked_pick = "You didn't make a selection this week."
        end
      end
    end

    # Current fixture list
    if @active_matchweek
      @fixtures = @active_matchweek.fixtures
    else
      @fixtures = []
    end

    # My historical picks
    @picks = @league.picks.where(:user_id => current_user)

    # League Standings
    @users = get_player_standings.sort_by {|user| [-user[:result_points],-user[:result_gd]]}

    # League Table
    @table = get_league_table['standing']
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
    response = HTTParty.get(LEAGUE_TABLE_URL,
                              :headers => {
                                "X-Auth-Token" => ENV['football_data']
                              }
                            ).parsed_response
  end

  def get_active_matchweek
    Matchweek.find_by(:status => :activated)
  end

  def league
    @league ||= League.find(params[:id])
  end

  def pick_for_matchweek(matchweek_id)
    current_user.picks.find_by(league_id: league.id, matchweek_id: matchweek_id)
  end
end
