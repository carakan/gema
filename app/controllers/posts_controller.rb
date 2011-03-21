# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class PostsController < ApplicationController
  #before_filter :revisar_permiso!
  layout false

  # GET /posts
  # GET /posts.xml
  def index
    q = {:conditions => set_conditions, :include => :adjuntos}.merge(order_query_params("posts.created_at"))
    @posts = Post.paginate( q )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new(:postable_id => params[:postable_id], :postable_type => params[:postable_type])
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    if @post.save
      redirect_to @post
    else
      render :action => "new"
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
private
  def set_conditions
    { :postable_id => params[:postable_id], :postable_type => params[:postable_type] }
  end

end
