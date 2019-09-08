module PostsHelper

    def my_post?(post)
        post.user == current_user
    end

end
