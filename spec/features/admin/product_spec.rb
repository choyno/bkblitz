require 'spec_helper'

feature 'Product admin' do
  background do
    FactoryGirl.create(:test_product_1)
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

    within('table#products') do
      page.should have_content 'Test Supplier 1'
      page.should have_content 'Test Product 1'
    end
    page.should have_no_link 'add'
    page.should have_no_link 'edit'
    page.should have_no_link 'delete'

    visit '/products/new'
    page.status_code.should eql 404

    visit '/products/1'
    current_path.should eql '/products/1'
    page.should have_content 'Test Supplier 1'
    page.should have_content 'Test Product 1'
    page.should have_content 50
    page.should have_content 100
    page.should have_content 'This is the description of test product 1'
    page.should have_no_link 'save'
    page.should have_no_link 'edit'
    page.should have_no_link 'delete'

    visit '/products/1/edit'
    page.status_code.should eql 404
  end

  scenario "admin REST paths, unauthorized" do
    visit '/admin/products'
    page.status_code.should eql 401
  end

  scenario "admin REST paths, authorized" do
    basic_auth('admin', 'blitzgift')

    visit '/admin/products'
    current_path.should eql '/admin/products'

    page.has_xpath?('//table/tr')
    page.has_css?('table#products')
    page.should have_selector('table tr', count: 2)

    within('table#products') do
      page.should have_content 'Test Supplier 1'
      page.should have_content 'Test Product 1'
      page.should have_link 'edit'
    end
    page.should have_link 'add'
    page.should have_no_link 'delete'

    click_link 'add'
    current_path.should eql '/admin/products/new'

    click_on 'Save'
    page.should have_content '5 errors prohibited this product from being saved'
    page.should have_content 'Supplier is required'
    page.should have_content 'Name is required'
    page.should have_content 'Wholesale price is required'
    page.should have_content 'Retail price is required'
    page.should have_content 'Description is required'

    fill_in "Name", with: "Test Product 2"
    fill_in "Wholesale Price", with: 100
    fill_in "Retail Price", with: 200
    fill_in "Description", with: "This is the description of test product 2"
    select "Test Supplier 1", from: "Supplier"

    click_on 'Save'
    page.status_code.should eql 200
    current_path.should eql '/admin/products'

    page.has_xpath?('//table/tr')
    page.has_css?('table#products')
    page.should have_selector('table tr', count: 3)

    #check for contents of supplier
    within("table#products") do
      page.should have_content 'Test Product 1'
      page.should have_content 'Test Product 2'
    end

    within('tr', :text => 'Test Product 2') do
      page.should have_link('edit')
      click_on 'edit'
    end

    current_path.should eql '/admin/products/2/edit'

    within('form#product_form') do
      find_field("Name").value.should eql "Test Product 2"
      find_field("Wholesale Price").value.should eql "100.00"
      find_field("Retail Price").value.should eql "200.00"
      find_field("Description").text.should eql "This is the description of test product 2"
      find_field("Supplier").text.should eql "Test Supplier 1"
    end

    fill_in "Name", with: "Test Product 2 edited"
    click_on 'Save'
    page.status_code.should eql 200
    current_path.should eql '/admin/products'

    within('table#products') do
      page.should have_content 'Test Product 1'
      page.should have_content 'Test Product 2 edited'
    end

    # delete not supported -- added products are permanent

  end
end
