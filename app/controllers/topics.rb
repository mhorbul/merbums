class Topics < Application
  # provides :xml, :yaml, :js
  
  before :login_required, :exclude => [:index, :show]
  before :find_forum
  
  def find_forum
    @forum ||= Forum.find(params[:forum_id])
  end
  
  def index
    @topics = @forum.topics.find(:all, :include => :posts, :order => "updated_at")
    display @topics
  end

  def show
    @topic = Topic.find(params[:id], :include => [:posts => [:attachments, :user]])
    @post = Post.new
    raise NotFound unless @topic
    display @topic
  end

  def new
    only_provides :html
    @topic = Topic.new(params[:topic])
    render
  end

  def create
    @topic = @forum.topics.new(params[:topic].merge(:user => current_user))
    if @topic.save
      flash[:notice] = @topic.title + " created successfully"
      redirect url(:forum_topic, :forum_id => @forum, :id => @topic)
    else
      render :new
    end
  end

  def edit
    only_provides :html
    @topic = Topic.find(params[:id])
    raise NotFound unless @topic
    render
  end

  def update
    @topic = Topic.find(params[:id])
    raise NotFound unless @topic
    if @topic.update_attributes(params[:topic])
      flash[:notice] = @topic.title + " updated successfully"
      redirect url(:forum_topic, :forum_id => @topic.forum, :id => @topic)
    else
      raise BadRequest
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    raise NotFound unless @topic
    if @topic.destroy
      redirect url(:forum, @topic.forum)
    else
      raise BadRequest
    end
  end
  
end
