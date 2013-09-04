require 'spec_helper'

feature 'Supplier admin' do
  background do
    # Mock one existing Supplier:
    #   Supplier
    #     name => "Test Supplier 1"
    #     contact_info => "supplier1@example.com"
    #     active? => true
  end
  
  def basic_auth(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "Driver does not support Basic HTTP Auth"
    end
  end

  scenario "default REST paths" do
    visit '/suppliers'
    response.status.should eql 404
    
    visit '/suppliers/new'
    response.status.should eql 404
    
    visit '/suppliers/1'
    response.status.should eql 404
        
    visit '/suppliers/1/edit'
    response.status.should eql 404
  end
  
  scenario "admin REST paths, unauthorized" do
    visit '/admin/suppliers'
    
    response.status.should eql 401
  end
  
  scenario "admin REST paths, authorized" do
    basic_auth('admin', 'blitzgift')
    
    visit '/admin/suppliers'
    current_path.should eql '/admin/suppliers'
    within_table('#suppliers') do
      table.should have_content 'Test Supplier'
      table.should have_link 'edit'
    end
    page.should have_link 'add'
    page.should have_no_link 'delete'
    
    click_link 'add'
    current_path.should eql '/admin/supplier/new'
    
    click_on 'Save'
    page.errors.on("Name").should eql 'is required'
    page.errors.on("Contact Info").should eql 'is required'
    
    fill_in "Name", with: "Test Supplier 2"
    fill_in "Contact Info", with: "supplier2@example.com"
    click_on 'Save'
    response.status.code.should eql 201
    current_path.should eql '/admin/suppliers'
    within_table('#suppliers') do
      table.should have_content 'Test Supplier 2'
    end
    
    click_on 'edit' # use edit link next for 'Test Supplier 2'
    current_path.should eql '/admin/supplier/2/edit'
    within_form('#supplier') do
      find_field("Name").value.should eql "Test Supplier 2"
      find_field("Contact Info").value should eql "supplier2@example.com"
    end
    
    fill_in "Name", with: "Test Supplier 2 edited"
    click_on 'Save'
    response.status.code.should eql 200
    current_path.should eql '/admin/suppliers'
     within_table('#suppliers') do
      table.should have_content 'Test Supplier 2 edited'
    end   
    
    # delete not supported -- added suppliers are permanent
  
  end
end

