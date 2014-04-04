class TalksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_talk, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  perspectives_actions

  def index
    respond_with(perspective('talks/index', all_talks: Talk.all))
  end

  def show
    respond_with(perspective('talks/show', talk: @talk))
  end

  def new
    respond_with(perspective('talks/new', talk: Talk.new))
  end

  def edit
    respond_with(perspective('talks/edit', talk: @talk))
  end

  def create
    @talk = Talk.new(talk_params)
    @talk.created_by = current_user

    respond_to do |format|
      if @talk.save
        format.html { redirect_to @talk, notice: 'Talk was successfully created.' }
        format.json { render action: 'show', status: :created, location: @talk }
      else
        format.html { render action: 'new' }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @talk.update(talk_params)
        format.html { redirect_to @talk, notice: 'Talk was successfully updated.' }
        format.json { head :no_content }
      else
        respond_with(perspective('talks/edit', talk: @talk))
      end
    end
  end

  def destroy
    @talk.destroy
    respond_to do |format|
      format.html { redirect_to talks_url }
      format.json { head :no_content }
    end
  end

  private

  def authorize!
    authorize_access!(current_user == @talk.created_by || current_user.admin?)
  end

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def talk_params
    params.require(:talk).permit(:title, :abstract, :speaker_id)
  end
end
