require 'spec_helper'

feature 'Contact Us mail form' do
  before :each do
    visit '/contactus'
  end

  scenario 'with blank email' do
    fill_in :email, :with => ''
    click_button 'Send'
    
    page.errors.on(:email).should == 'is required'
  end
  
  scenario 'with invalid email' do
    fill_in :email, :with => '@invalid'
    click_button 'Send'
    
    page.errors.on(:email).should == 'is not valid'
  end
  
  scenario 'with blank body' do
    fill_in :body, :with => ''
    click_button 'Send'
    
    page.errors.on(:body).should == 'is required'
  end
  
  scenario 'with valid email and body' do
    fill_in :email, :with => 'test@example.com'
    fill_in :body, :with => 'This is an automated test message.'
    click_button 'Send'
      
    page.should have_sent_email.to('contact@blitzgift.com')
    page.should have_content('sent')
  end
end
