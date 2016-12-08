class FixturesController < ApplicationController
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
      params.require(:fixture).permit(:home_team_id,:home_team_score,:away_team_score,:away_team_id,:matchweek_id,:external_id,:date)
    end
end
