require 'spec_helper'

feature 'Contact Us mail form' do
  before :each do
    visit '/contactus'
  end

  scenario 'with blank email' do
    fill_in :email, :with => ''
    click_button 'Send'
    
    #page.errors.on(:email).should == 'is required'
    expect(page).to have_content "Email can't be blank" 
  end
  
  scenario 'with invalid email' do
    fill_in :email, :with => '@invalid'
    click_button 'Send'
    
    #page.errors.on(:email).should == 'is not valid'
    expect(page).to have_content "Email is invalid"
  end
  
  scenario 'with blank body' do
    fill_in :body, :with => ''
    click_button 'Send'
    
    #page.errors.on(:body).should == 'is required'
    expect(page).to have_content "Body can't be blank" 
  end
  
  scenario 'with valid email and body' do
    fill_in :email, :with => 'test@example.com'
    fill_in :body, :with => 'This is an automated test message.'
    click_button 'Send'
      
    #page.should have_sent_email.to('contact@blitzgift.com')
    #page.should have_content('sent')
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to have_content('contact@blitzgift.com')
    expect(page).to have_content "Email was successfully sent."
  end
end
