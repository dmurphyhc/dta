class Admin::CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :set_institution, only: [:show, :edit, :update, :destroy, :new, :create]

  respond_to :html

  def index
    @collections = Collection.all
    respond_with([:admin, @collections])
  end

  def show
    respond_with([:admin, @collection])
  end

  def new
    @collection = Collection.new
    respond_with([:admin, @institution, @collection])
  end

  def edit
  end

  def create
  	require 'digest/md5'
    @collection = Collection.new(collection_params)
    @collection.id = Digest::MD5.hexdigest(@collection.name)
    @collection.institution_id = @institution
    @collection.save
    respond_with([:admin, @institution, @collection])
  end

  def update
    @collection.update(collection_params)
    respond_with([:admin, @collection])
  end

  def destroy
    @collection.destroy
    respond_with([:admin, @collection])
  end

  private
    def set_collection
      @collection = Collection.find(params[:id])
    end
    
    def set_institution
    	@institution = Institution.find(params[:institution_id])
    end

    def collection_params
      params.require(:collection).permit(:name)
    end
end
