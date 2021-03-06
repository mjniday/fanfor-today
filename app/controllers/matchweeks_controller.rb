class MatchweeksController < ApplicationController
  before_filter :validate_admin
  def index
    @matchweeks = Matchweek.all
  end

  def new
    @matchweek = Matchweek.new
  end

  def create
    @matchweek = Matchweek.new(matchweek_params)
    if @matchweek.save
      redirect_to @matchweek
    else
      render 'edit'
    end
  end

  def edit
    @matchweek = Matchweek.find(params[:id])
  end

  def update
    @matchweek = Matchweek.find(params[:id])
    if @matchweek.update_attributes(matchweek_params)
      redirect_to @matchweek
      else
        render 'edit'
      end
  end

  def show
    @matchweek = Matchweek.find(params[:id])
    @fixtures = @matchweek.fixtures.all
  end

  def edit
    @matchweek = Matchweek.find(params[:id])
  end

  def activate
    @matchweek = Matchweek.find(params[:id])
    @matchweek.activated!
    flash[:notice] = "Matchweek is now active!"
  end

  def archive
    @matchweek = Matchweek.find(params[:id])
    @matchweek.archived!
  end

  def populate_matchweek_fixtures
    @matchweek = Matchweek.find(params[:id])
    url = "http://api.football-data.org/v1/competitions/426/fixtures?matchday=#{@matchweek.week}"
    response = HTTParty.get(url,:headers => {'X-Auth-Token' => ENV['football_data']}).parsed_response
    fixture_list = response['fixtures']

    fixture_list.each do |f|
      # get id from football-data.org
      external_id = f['_links']['self']['href'].split("/")[-1]

      # Build the hash used to create a new fixture
      fixture_data = {}
      fixture_data['home_team_id'] = Team.find_by(:external_id => f['_links']['homeTeam']['href'].split("/")[-1]).id
      fixture_data['home_team_score'] = f['result']['goalsHomeTeam']
      fixture_data['away_team_id'] = Team.find_by(:external_id => f['_links']['awayTeam']['href'].split("/")[-1]).id
      fixture_data['away_team_score'] = f['result']['goalsAwayTeam']
      fixture_data['date'] = Time.parse(f['date'])

      # Find the existing Fixture, or initialize a new one 
      # Initialize_by works like Class.new as opposed to Class.create. It doesn't save
      @fixture = @matchweek.fixtures.find_or_initialize_by(:external_id => external_id)
      @fixture.update_attributes(fixture_data)
      @fixture.save
    end
  end

  private
  def matchweek_params
    params.require(:matchweek).permit(:week,:status)
  end

  def validate_admin
    unless current_user.admin
      redirect_to '/'
      flash[:alert] = "You don't have access to those pages"
    end
  end
end
