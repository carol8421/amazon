class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :add_in_stock, :add_to_order, :add_wish, :remove_wish, :wishers]
  before_filter :authenticate_customer!, only: [:add_to_order, :add_wish, :remove_wish]
 
  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end
 
  # GET /books/1
  # GET /books/1.json
  def show
    @current_book = Book.find(@book.id)
    @rating = @book.ratings.new
  end
 
  # GET /books/new
  def new
    if current_customer.admin == true
      @book = Book.new
    end
  end
 
  # GET /books/1/edit
  def edit
    if current_customer.admin == true
    end
  end
 
  # POST /books
  # POST /books.json
  def create
    if current_customer.admin == true
      @book = Book.new(book_params)
   
      respond_to do |format|
        if @book.save
          format.html { redirect_to @book, notice: 'Book was successfully created.' }
          format.json { render action: 'show', status: :created, location: @book }
        else
          format.html { render action: 'new' }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    if current_customer.admin == true
      respond_to do |format|
        if @book.update(book_params)
          format.html { redirect_to @book, notice: 'Book was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    if current_customer.admin == true
      @book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: 'Book was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  def add_in_stock
    if current_customer.admin == true
      @book.add_in_stock!
      redirect_to :back
    end 
  end

  def add_to_order
    if current_customer.order_items.in_cart_with(@book).empty?
      current_customer.order_items.create(book_id: @book.id, quantity: 1)
    else
      current_customer.order_items.find_by(order_id: nil, book_id: @book.id).increase_quantity!
    end
    redirect_to new_order_path
  end

  def author_filter
    @author = Author.find(params[:author_id])
    @books = Book.by_author(@author)
  end
 
  def category_filter
    @category = Category.find(params[:category_id])
    @books = Book.by_category(@category)
  end

  def add_wish
    @book.wishers << current_customer unless current_customer.wishes.include?(@book)
    redirect_to :back, notice: "Book was successfully added to wish list."
  end

  def remove_wish
    @book.wishers.delete(current_customer)
    redirect_to :back, alert: "Book was successfully deleted from wish list."
  end

  def wishers
    @wishers = @book.wishers
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :description, :price, :in_stock, :author_id, :category_id)
    end
end
