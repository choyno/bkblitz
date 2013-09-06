require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User registration' do
  background do
    # mock one existing User: email => "test1@example.com", name => "Test User1", password => "password1"
  end
  
  def log_in_with(email, password)
    visit '/login'
    fill_in :user_email, :with => email
    fill_in :user_password, :with => password
    click_button 'Log In'
  end
  
  scenario 'default is not logged in' do
    visit root_url
    
    page.should have_link('Register')
    page.should have_link('Login')
    page.should have_no_link('My Account')
    page.should have_no_link('Logout')
  end
  
  scenario 'login attempt with blank email' do
    log_in_with('', 'password')
    
    page.should have_content('Invalid email or password.')
  end
  
  scenario 'login attempt with blank password' do
    log_in_with('test1@example.com', '')
    
    page.should have_content('Invalid email or password.')
  end
  
  scenario 'login attempt with invalid email/password combination' do
    log_in_with('test1@example.com', 'wrongpassword')

    page.should have_content('Invalid email or password.')
  end
  
  scenario 'register new user with blank email' do
    visit '/register'
    
    fill_in :user_email, :with => ''
    click_button 'Register'
    
    page.should have_content('Email can\'t be blank')
  end
  
  scenario 'register new user with pre-existing email' do
    user = FactoryGirl.create(:user)
    visit '/register'
    
    fill_in :user_email, :with => user.email
    fill_in :user_name, :with => user.name
    fill_in :user_password, :with => 'password'
    fill_in :user_password_confirmation, :with => 'password'
    click_button 'Register'
    
    page.should have_content('Email has already been taken')
  end
  
  scenario 'register new user with blank name' do
    visit '/register'
    
    fill_in :user_name, :with => ''
    click_button 'Register'
    
    page.should have_content('Name can\'t be blank')
  end
  
  scenario 'register new user with blank password' do
    visit '/register'
    
    fill_in :user_password, :with => ''
    click_button 'Register'
    
    page.should have_content('Password can\'t be blank')
  end
  
  scenario 'register new user with mismatching password confirmation' do
    visit '/register'
    
    fill_in :user_email, :with => 'test2@example.com'
    fill_in :user_name, :with => 'Test User2'
    fill_in :user_password, :with => 'password2'
    fill_in :user_password_confirmation, :with => '2wordpass'
    click_button 'Register'
    
    page.should have_content('Password doesn\'t match confirmation')
  end
  
  scenario 'register new user with valid info' do
    visit '/register'
    
    fill_in :user_email, :with => 'test2@example.com'
    fill_in :user_name, :with => 'Test User2'
    fill_in :user_password, :with => 'password2'
    fill_in :user_password_confirmation, :with => 'password2'
    click_button 'Register'
    
    page.should have_content 'Welcome! You have signed up successfully.'
    page.should have_no_link('Register')
    page.should have_no_link('Login')
    page.should have_link('My Account')
    page.should have_link('Logout')
  end

  scenario 'login attempt with valid info' do
    user = FactoryGirl.create(:user)
    log_in_with(user.email, 'password')
    
    page.should have_no_link('Register')
    page.should have_no_link('Login')
    page.should have_link('My Account')
    page.should have_link('Logout')      
  end
  
  scenario 'logout' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    
    visit '/logout'
    
    current_path.should eql '/login'
    page.should have_link('Register')
    page.should have_link('Login')
    page.should have_no_link('My Account')
    page.should have_no_link('Logout')       
  end
  
  scenario 'my account page' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    
    visit '/myaccount'
    
    page.should have_content user.email
    page.should have_content user.name
  end
end
