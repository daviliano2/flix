class FavoritesController < ApplicationController

	before_action :require_signin
	before_action :set_movie

	def create
		@movie.favorites.create!(user: current_user)
		# OR APPEND THROUGH ASSOCIATON (CHECK LINE 5 OF MOVIE.RB)
		# @movie.fans << current_user
		redirect_to @movie, notice: "Thanks for fav'ing!"
	end

	def destroy
		favorite = current_user.favorites.find(params[:id]) #params[:id] CONTAINS THE FAV ID THAT IT IS THE SECOND IN THE DELETE ROUTE.
		favorite.destroy
		redirect_to @movie, notice: "Sorry you unfaved it!"
	end

private
	
	def set_movie
		# @movie = Movie.find(params[:movie_id])
		@movie = Movie.find_by!(slug: params[:movie_id])
	end

end
