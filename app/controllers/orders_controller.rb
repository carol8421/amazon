class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :shipped, :complete]
  before_filter :authenticate_customer!, only: [:index, :show, :new, :update]
 
  # GET /orders
  # GET /orders.json
  def index
    @orders = current_customer.orders.load
  end
 
  # GET /orders/1
  # GET /orders/1.json
  def show
  end
 
  # GET /orders/new
  def new
    @order = current_customer.orders.new
    @order.build_credit_card
    @order.build_bill_address
    @order.build_ship_address
  end
 
  # GET /orders/1/edit
  def edit
    if current_customer.admin == true
    end
  end
 
  # POST /orders
  # POST /orders.json
  def create
    @order = current_customer.orders.new(order_params)
    @order.state = 'in_progress'
    @order.price = current_customer.order_price
    respond_to do |format|
      if !current_customer.order_items.empty?
        if @order.save
          current_customer.order_items.where(order_id: nil).update_all(order_id: @order.id)
          @order = Order.find(@order.id)
          @order.decrease_in_stock!
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render action: 'show', status: :created, location: @order }
        else
          format.html { render action: 'new'}
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to books_path, alert: 'Please, select some book(s) to buy first'}
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if current_customer.admin == true
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to @order, notice: 'Order was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    if current_customer.admin == true
      @order.return_in_stock!
      @order.destroy
      respond_to do |format|
        format.html { redirect_to orders_url, notice: 'Order was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  def shipped
    if current_customer.admin == true
      @order.shipped!
      redirect_to :back
    end
  end

  def complete
    if current_customer.admin == true
      @order.complete!
      redirect_to :back
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(credit_card_attributes: [:id, :number, :cvv, :firstname, :lastname, :expiration_month, :expiration_year], bill_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id], ship_address_attributes: [:id, :city, :address, :phone, :zipcode, :country_id])
    end
end

