require 'spec_helper'

feature 'Product admin' do
  background do
    # Mock one existing Supplier and Product:
    #   Supplier
    #     name => "Test Supplier"
    #     contact_info => "supplier@example.com"
    #     active? => true
    #   Product
    #     name => "Test Product 1"
    #     wholesale_price => 50.00
    #     retail_price => 100.00
    #     description => "This is the description of test product 1"
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
    visit '/products'
    current_path.should eql '/products'
    within_table('#products') do
      table.should have_content 'Test Supplier'
      table.should have_content 'Test Product 1'
    end
    page.should have_no_link 'add'
    page.should have_no_link 'edit'
    page.should have_no_link 'delete'
    
    visit '/products/new'
    response.status.should eql 404
    
    visit '/products/1'
    current_path.should sql '/products/1'
    page.should have_content 'Test Supplier'
    page.should have_content 'Test Product 1'
    page.should have_content 50
    page.should have_content 100
    page.should have_content 'This is the description of test product 1'
    page.should have_no_link 'save'
    page.should have_no_link 'delete'
        
    visit '/products/1/edit'
    response.status.should eql 404
  end
  
  scenario "admin REST paths, unauthorized" do
    visit '/admin/products'
    
    response.status.should eql 401
  end
  
  scenario "admin REST paths, authorized" do
    basic_auth('admin', 'blitzgift')
    
    visit '/admin/products'
    current_path.should eql '/admin/products'
    within_table('#products') do
      table.should have_content 'Test Supplier'
      table.should have_content 'Test Product 1'
      table.should have_link 'edit'
    end
    page.should have_link 'add'
    page.should have_no_link 'delete'
    
    click_link 'add'
    current_path.should eql '/admin/product/new'
    
    click_on 'Save'
    page.errors.on("Supplier").should eql 'is required'
    page.errors.on("Name").should eql 'is required'
    page.errors.on("Wholesale Price").should eql 'is required'
    page.errors.on("Retail Price").should eql 'is required'
    page.errors.on("Description").should eql 'is required'
    
    select "Test Supplier", :from => "Supplier"
    fill_in "Name", with: "Test Product 2"
    fill_in "Wholesale Price", with: 100
    fill_in "Retail Price", with: 200
    fill_in "Description", with: "This is the description of test product 2"
    click_on 'Save'
    response.status.code.should eql 201
    current_path.should eql '/admin/products'
    within_table('#products') do
      table.should have_content 'Test Product 2'
    end
    
    click_on 'edit' # use edit link next for 'Test Product 2'
    current_path.should eql '/admin/product/2/edit'
    within_form('#product') do
      find_field("Supplier").selected.should eql "Test Supplier"
      find_field("Name").value.should eql "Test Product 2"
      find_field("Wholesale Price").value.should eql 100.00
      find_field("Retail Price").value.should eql 200.00
      find_field("Description").value should eql "This is the description of test product 2"
    end
    
    fill_in "Name", with: "Test Product 2 edited"
    click_on 'Save'
    response.status.code.should eql 200
    current_path.should eql '/admin/products'
     within_table('#products') do
      table.should have_content 'Test Product 2 edited'
    end   
    
    # delete not supported -- added products are permanent
  
  end
end
