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

	def lock
		@matchweek = Matchweek.find(params[:id])
		@matchweek.locked!
		flash[:notice] = "Matchweek is now locked!"
	end

	def archive
		@matchweek = Matchweek.find(params[:id])
		@matchweek.archived!
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
