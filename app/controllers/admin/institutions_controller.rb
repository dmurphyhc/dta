class Admin::InstitutionsController < ApplicationController
  before_action :set_institution, only: [:show, :edit, :update, :destroy, :addCollection]

  respond_to :html

  def index
    @institutions = Institution.all
    respond_with([:admin, @institutions])
  end

  def show
    respond_with([:admin, @institution])
  end

  def new
    @institution = Institution.new
    respond_with([:admin, @institution])
  end

  def edit
  end

  def create
  	require 'digest/md5'
    @institution = Institution.new(institution_params)
    @institution.id = Digest::MD5.hexdigest(@institution.name)
    @institution.save
    respond_with([:admin, @institution])
  end

  def update
    @institution.update(institution_params)
    respond_with([:admin, @institution])
  end

  def destroy
    @institution.destroy
    respond_with([:admin, @institution])
  end

  private
    def set_institution
      @institution = Institution.find(params[:id])
    end

    def institution_params
      params.require(:institution).permit(:name, :info, :url, :address, :contact)
    end
end
