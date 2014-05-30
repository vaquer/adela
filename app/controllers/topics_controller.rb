class TopicsController < ApplicationController
  respond_to :html, :json

  # FIXME Should move this to the ApplicationController
  before_action :authenticate_user!

  layout 'home'

  def index
    respond_to do |format|
      format.html do
        # FIXME When do we show this notice?
        flash[:notice] = "Bienvenido, el primer paso es crear tu plan de apertura"
      end
      format.json { render :json => current_organization.topics.sorted }
    end
  end

  def create
    @topic = current_organization.topics.build(topic_params)
    @topic.save

    respond_with @topic
  end

  def update
    @topic = current_organization.topics.find(params[:id])

    if @topic.update(topic_params)
      render :json => @topic, :status => :ok
    else
      render :json => { :errors => @topic.errors }, :status => :unprocessable_entity
    end
  end

  def sort_order
    topics = params[:topic].map { |id| current_organization.topics.find(id) }
    topics.each_with_index { |topic, index|
      topic.update_column :sort_order, index+1
    }
    render :json => {}, :status => :ok
  end

  def destroy
    @topic = current_organization.topics.find(params[:id])
    if @topic.destroy
      current_organization.topics.each_with_index { |topic, index|
        topic.update_column :sort_order, index+1
      }
      render :json => {}, :status => :ok
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :owner, :description)
  end
end
