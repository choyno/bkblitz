require 'spec_helper'

feature 'Supplier admin' do
  background do
    FactoryGirl.create(:test_supplier_1)
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
    page.status_code.should eql 404

    visit '/suppliers/new'
    page.status_code.should eql 404

    visit '/suppliers/1'
    page.status_code.should eql 404

    visit '/suppliers/1/edit'
    page.status_code.should eql 404
  end

  scenario "admin REST paths, unauthorized" do
    visit '/admin/suppliers'
    page.status_code.should eql 401
  end

  scenario "admin REST paths, authorized" do
    basic_auth('admin', 'blitzgift')

    visit '/admin/suppliers'
    current_path.should eql '/admin/suppliers'

    page.has_xpath?('//table/tr')
    page.has_css?('table#suppliers')
    page.should have_selector('table tr', count: 2)

    #check for contents of supplier
    within("table#suppliers") do
      page.should have_content 'Test Supplier 1'
      page.should have_link 'edit'
    end

    #check for links on supplier
    within('tr', :text => 'Test Supplier 1') do
      page.should have_link('edit')
      page.should have_link('show')
      page.should_not have_link('delete')
    end

    page.should have_link 'add'
    page.should have_no_link 'delete'

    click_link 'add'
    current_path.should eql '/admin/suppliers/new'

    click_on 'Save'
    page.should have_content '2 errors prohibited this supplier from being saved'
    page.should have_content 'Name is required'
    page.should have_content 'Contact info is required'

    fill_in "Name", with: "Test Supplier 2"
    fill_in "Contact Info", with: "supplier2@example.com"
    click_on 'Save'
    page.status_code.should eql 200
    current_path.should eql '/admin/suppliers'

    page.has_xpath?('//table/tr')
    page.has_css?('table#suppliers')
    page.should have_selector('table tr', count: 3)

    #check for contents of supplier
    within("table#suppliers") do
      page.should have_content 'Test Supplier 1'
      page.should have_content 'Test Supplier 2'
    end

    within('tr', :text => 'Test Supplier 2') do
      page.should have_link('edit')
      click_on 'edit'
    end

    current_path.should eql '/admin/suppliers/2/edit'

    within("form#supplier_form") do
      find_field("Name").value.should eql "Test Supplier 2"
      find_field("Contact Info").text.should eql "supplier2@example.com"
    end

    fill_in "Name", with: "Test Supplier 2 edited"
    click_on 'Save'

    page.status_code.should eql 200
    current_path.should eql '/admin/suppliers'

    #check for contents of table
    within("table#suppliers") do
      page.should have_content 'Test Supplier 1'
      page.should have_content 'Test Supplier 2 edited'
    end

    # delete not supported -- added suppliers are permanent

  end
end
