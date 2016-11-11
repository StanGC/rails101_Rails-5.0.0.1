class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:new, :create]

	def new
		@group = Group.find(params[:group_id])
		@post = Post.new
	end

	def create
		@group = Group.find(params[:group_id])
		@post = Post.new(post_params)
		@post.group = @group
		@post.user = current_user
		if @post.save
			redirect_to group_path(@group)
		else
			render :new
		end
	end

	def join
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:notice] = "加入本討論版成功!"
		else
			flash[:warning] = "你已經是本討論版成員了!"
		end

		redirect_to group_path(@group)
	end

	def quit
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.quit!(@group)
			flash[:alert] = " 已退出本討論版!"
		else
			flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
		end

		redirect_to group_path(@group)
	end

	private
	def post_params
		params.require(:post).permit(:content)
	end
end
