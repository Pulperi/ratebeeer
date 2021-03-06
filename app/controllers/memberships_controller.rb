class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy, :toggle_active]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    if current_user.nil?
      redirect_to beer_clubs_path
    else
      @membership = Membership.new(membership_params)
      @membership.user_id = current_user.id
      # byebug
      respond_to do |format|
        if @membership.save
          format.html { redirect_to @membership.beer_club, notice: "#{current_user.username}, welcome to the club!" }
          format.json { render :show, status: :created, location: current_user }
        else
          @beer_clubs = BeerClub.all
          format.html { render :new }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def toggle_active
    if current_user.nil?
      redirect_to beer_clubs_path
    else
      if not current_user.memberships.where(:beer_club_id => @membership.beer_club_id, :active => true).first.nil?
        @membership.active = true
        @membership.save
        redirect_to :back, notice:"#{@membership.user.username} is now a member of #{@membership.beer_club.name}"
      else
        redirect_to beer_clubs_path
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        current_user.memberships << @membership
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id)
    end
end
