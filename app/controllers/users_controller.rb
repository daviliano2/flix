class UsersController < ApplicationController

	before_action :require_signin, except: [:new, :create]
	before_action :require_correct_user, only: [:edit, :update]
	before_action :require_admin, only: [:destroy]
	before_action :set_user, only: [:show, :destroy]
	# TO TURN AN USER INTO ADMIN WE HAVE TO DO IT FROM THE CONSOLE,
	# user.admin = true
	# THEN CHECK IF THE USER IS AN ADMIN,
	# user.admin?
	# FINALLY SAVE THE CHANGES,
	# user.save

	def index
		@users = User.all
	end

	def show
		@reviews = @user.reviews
		@favorite_movies = @user.favorite_movies
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			redirect_to @user, notice: "Thanks for signing up!"
		else
			render :new
		end
	end

	def edit
		# @user = User.find(params[:id]) 
		# BECAUSE THE BEFORE_ACTION METHOD "REQUIRE_CORRECT_USER" IS ALREADY FINDING THE USER AND THIS METHOD WILL 
		# RUN BEFORE EDIT, UPDATE AND DESTROY, THEN WE CAN REMOVE THIS LINE FROM EACH ACTION
	end

	def update
		# @user = User.find(params[:id]) 
		# BECAUSE THE BEFORE_ACTION METHOD "REQUIRE_CORRECT_USER" IS ALREADY FINDING THE USER AND THIS METHOD WILL 
		# RUN BEFORE EDIT, UPDATE AND DESTROY, THEN WE CAN REMOVE THIS LINE FROM EACH ACTION
		if @user.update(user_params)
			redirect_to @user, notice: "Account successfully updated!"
		else
			render :edit
		end
	end

	def destroy
		@user.destroy
		session[:user_id] = nil
		redirect_to root_url, alert: "Account successfully deleted!"
	end

private

	def require_correct_user
		# @user = User.find_by!(slug: params[:id])
		# unless current_user == @user
		# 	redirect_to root_url
		# end
		
		set_user
		redirect_to root_url unless current_user?(@user)
	end

	def user_params
		params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
	end

	def set_user
		@user = User.find_by!(slug: params[:id])
	end

end
