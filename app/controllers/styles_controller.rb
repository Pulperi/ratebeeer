class StylesController < ApplicationController
  before_action :set_style, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :destroy]
  before_action :ensure_that_admin, only: [:destroy]

  def index
    @styles = Style.all
  end

  def show

  end

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to styles_path, notice: 'Style was successfully created.' }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style.destroy
    respond_to do |format|
      format.html { redirect_to styles_path, notice: 'Style was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @style.update(style_params)
        format.html { redirect_to @style, notice: 'Style was successfully updated.' }
        format.json { render :show, status: :ok, location: @style }
      else
        format.html { render :edit }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_style
    @style = Style.find (params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :desc)
  end

end