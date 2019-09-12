class PostsController < ApplicationController
    def index
        @posts = Post.all
        @ranking = REDIS.zrevrange "ranking", 0, 2, withscores: true
    end
    
    def show
        @post = Post.find(params[:id])
        REDIS.zincrby "ranking", 1, "#{@post.title}"
        @ranking = REDIS.zrevrange "ranking", 0, 2, withscores: true
    end

    def new
        @post = Post.new
    end

    def create
        post = current_user.posts.build(post_params)
        if post.save
            redirect_to post_path(post) 
        else
            redirect_to new_post_path
            flash[:error] = "タイトルと内容を記入しましょう"
        end
    end

    def destroy
        post = Post.find(params[:id])
        if post.user != current_user
            redirect_to root_path
            flash[:warning] = "Not Yours"
            return
        end
        post.delete
        REDIS.zrem('ranking', post.title)
        redirect_to root_path
    end

    def edit
        @post = Post.find(params[:id])
        if @post.user != current_user
            redirect_to root_path
            flash[:warning] = "Not Yours"
        end
    end

    def update
        post = Post.find(params[:id])
        if post.update_attributes(post_params)
            redirect_to post_path(post)
        else
            redirect_to edit_post_path(post)
            flash[:error] = "タイトルと内容を記入しましょう"
        end
    end

    private 
        def post_params
            params.require(:post).permit(:title, :description, :user_id)
        end
end
