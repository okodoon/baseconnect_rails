class PostsController < ApplicationController
    def index
        @posts = Post.all
    end
    
    def show
        @post = Post.find(params[:id])
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to post_path(@post) 
        else
            redirect_to new_post_path
            # flash[:error] = "タイトルと内容を記入しましょう"
        end
    end

    def destroy
    end

    def edit
    end

    def update
    end

    private 
        def post_params
            params.require(:post).permit(:title, :description, :user_id)
        end
end
