class Posts < Application
  # provides :xml, :yaml, :js
  before :login_required, :exclude => [:index, :show]
  before :find_forum_and_topic
  
  def find_forum_and_topic
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @post = Post.new(params[:post].merge({ :user => current_user, :forum_id => @forum.id, :topic_id => @topic.id }))
    if @post.save
      flash[:notice] = "Post Created"
      redirect url(:forum_topic, { :forum_id => @forum, :id => @topic })
    else
      render :new
    end
  end
  
  def edit
    only_provides :html
    @post = Post.find(params[:id])
    raise NotFound unless @post
    render
  end

  def update
    @post = Post.find(params[:id])
    raise NotFound unless @post
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post Updated"
      redirect url(:forum_topic, { :forum_id => @forum, :id => @topic })
    else
      raise BadRequest
    end
  end

  def destroy
    @post = Post.find(params[:id])
    raise NotFound unless @post
    if @post.destroy
      redirect url(:posts)
    else
      raise BadRequest
    end
  end
  
end
