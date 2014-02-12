class CreditCardsController < ApplicationController
  before_action :set_credit_card, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_customer!
  # GET /credit_cards
  # GET /credit_cards.json
  def index
    @credit_cards = CreditCard.all
  end
 
  # GET /credit_cards/1
  # GET /credit_cards/1.json
  def show
  end
 
  # GET /credit_cards/new
  def new
    if current_customer.credit_card.nil?
      @credit_card = current_customer.build_credit_card
    else
      redirect_to edit_customer_registration_path, alert: 'You already have credit card. Edit it if you want.'
    end
  end
 
  # GET /credit_cards/1/edit
  def edit
  end
 
  # POST /credit_cards
  # POST /credit_cards.json
  def create
    @credit_card = current_customer.build_credit_card(credit_card_params)
 
    respond_to do |format|
      if @credit_card.save
        format.html { redirect_to edit_customer_registration_path, notice: 'Credit card was successfully created.' }
        format.json { redirect_to edit_customer_registration_path, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /credit_cards/1
  # PATCH/PUT /credit_cards/1.json
  def update
    respond_to do |format|
      if @credit_card.update(credit_card_params)
        format.html { redirect_to edit_customer_registration_path, notice: 'Credit card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /credit_cards/1
  # DELETE /credit_cards/1.json
  def destroy
    @credit_card.destroy
    respond_to do |format|
      format.html { redirect_to edit_customer_registration_path, notice: 'Credit card was successfully deleted.' }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_card_params
      params.require(:credit_card).permit(:number, :cvv, :expiration_month, :expiration_year, :firstname, :lastname, :customer_id)
    end
end

