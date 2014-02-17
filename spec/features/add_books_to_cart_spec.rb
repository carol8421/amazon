require 'spec_helper'

feature "Add books to cart" do
  given!(:author) {FactoryGirl.create(:author)}
  given!(:category) {FactoryGirl.create(:category)}
  given!(:customer) {FactoryGirl.create(:customer)}
  given!(:book) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 1, author: author, category: category)}
  given!(:book_that_not_in_stock) {FactoryGirl.create(:book, title: "LOTR", price: 10.00, in_stock: 0, author: author, category: category)}

  before do
    visit new_customer_session_path
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'
  end

  scenario "A customer adds book to cart successfully by pressing 'Add to cart' button from index show" do
    visit book_path(book)
    click_on 'Add to cart'
    expect(page).to have_content book.title
    expect(customer.order_items.load.count).to eq(1) 
  end
  scenario "A customer adds successfully by pressing 'Add to cart' button in show view" do
    visit books_path
    click_on 'Add to cart'
    expect(page).to have_content book.title
    expect(customer.order_items.load.count).to eq(1) 
  end
  scenario "A customer can not see 'Add to cart' button but see that book not in stock if it's true" do
    visit book_path(book_that_not_in_stock)
    expect(page).to_not have_content 'Add to cart'
    expect(page).to have_content 'Sorry, we dont have this book right now'
  end
  scenario "A visitor can not add to book cart and see 'sign in' view if he not signed in" do
    click_on 'Sign out'
    visit book_path(book)
    click_on 'Add to cart'
    expect(page).to have_link('Sign in')
  end
end