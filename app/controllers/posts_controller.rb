class PostsController < ApplicationController
    before_action :logged_in_user, except: [:index, :show]
    before_action :correct_user, only: [:edit, :update, :destroy]
  

    def index
        @posts = Post.order(updated_at: :desc) 
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)
        @post.user_id = current_user.id
        if @post.save
            flash[:success] = "Successfully posted!"
            redirect_to posts_path
        else
            render 'new'
        end
    end

    def destroy
        Post.find(params[:id]).destroy
        flash[:success] = "Post successfully deleted!"
        redirect_to posts_path
    end

    # Private methods
    private

        def post_params
            params.require(:post).permit(:header, :content)
        end

        # Before filters

        # Confirms a logged-in user 
        def logged_in_user
            unless logged_in?
            store_location
            flash[:danger] = "Please log in!"
            redirect_to login_path
            end
        end
        
        # Confirms the correct user
        def correct_user
            post = Post.find(params[:id])
            user = post.user
            redirect_to(root_url) unless current_user?(user)
        end

end
