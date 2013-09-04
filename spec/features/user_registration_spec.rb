require 'spec_helper'

feature 'User registration' do
  background do
    # mock one existing User: email => "test1@example.com", name => "Test User1", password => "password1"
  end
  
  def log_in_with(email, password)
    visit '/login'
    fill_in :email, :with => email
    fill_in :password, :with => password
    click_button 'Log In'
  end
  
  scenario 'default is not logged in' do
    visit root_url
    
    page.should have_link('register')
    page.should have_link('login')
    page.should have_no_link('myaccount')
    page.should have_no_link('logout')
  end
  
  scenario 'login attempt with blank email' do
    log_in_with('', 'password')
    
    page.errors.on(:email).should eql 'is required'
  end
  
  scenario 'login attempt with blank password' do
    log_in_with('test1@example.com', '')
    
    page.errors.on(:password).should eql 'is required'
  end
  
  scenario 'login attempt with invalid email/password combination' do
    log_in_with('test1@example.com', 'wrongpassword')
    
    page.errors.should have_text 'not match'
  end
  
  scenario 'register new user with blank email' do
    visit '/register'
    
    fill_in :email, :with => ''
    click_button 'Register'
    
    page.errors.on(:email).should eql 'is required'
  end
  
  scenario 'register new user with pre-existing email' do
    visit '/register'
    
    fill_in :email, :with => 'test1@example.com'
    click_button 'Register'
    
    page.errors.on(:email).should have_text 'already registered'
  end
  
  scenario 'register new user with blank name' do
    visit '/register'
    
    fill_in :name, :with => ''
    click_button 'Register'
    
    page.errors.on(:name).should eql 'is required'
  end
  
  scenario 'register new user with blank password' do
    visit '/register'
    
    fill_in :password, :with => ''
    click_button 'Register'
    
    page.errors.on(:password).should eql 'is required'
  end
  
  scenario 'register new user with mismatching confirmpassword' do
    visit '/register'
    
    fill_in :email, :with => 'test2@example.com'
    fill_in :name, :with => 'Test User2'
    fill_in :password, :with => 'password2'
    fill_in :confirmpassword, :with => '2wordpass'
    click_button 'Register'
    
    page.errors.on(:confirmpassword).should have_text 'not match'
  end
  
  scenario 'register new user with valid info' do
    visit '/register'
    
    fill_in :email, :with => 'test2@example.com'
    fill_in :name, :with => 'Test User2'
    fill_in :password, :with => 'password2'
    fill_in :confirmpassword, :with => 'password2'
    click_button 'Register'
    
    page.should have_content 'registered'
    page.should have_no_link('register')
    page.should have_no_link('login')
    page.should have_link('myaccount')
    page.should have_link('logout')    
  end

  scenario 'login attempt with valid info' do
    log_in_with('test2@example.com', 'password2')
    
    page.should have_no_link('register')
    page.should have_no_link('login')
    page.should have_link('myaccount')
    page.should have_link('logout')      
  end
  
  scenario 'logout' do
    log_in_with('test1@example.com', 'password1')
    
    visit '/logout'
    
    current_path.should eql '/login'
    page.should have_link('register')
    page.should have_link('login')
    page.should have_no_link('myaccount')
    page.should have_no_link('logout')       
  end
  
  scenario 'my account page' do
    log_in_with('test1@example.com', 'password1')
    
    visit '/myaccount'
    
    page.should have_content 'test1@example.com'
    page.should have_content 'Test User1'
  end
end
