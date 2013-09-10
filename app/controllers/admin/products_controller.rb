class Admin::ProductsController < Admin::ApplicationController
  ###########
  ## Filters
  ###########
  skip_before_filter :authorize, only: [:index, :show]
  before_filter :authorize_admin_path_only, only: [:index, :show]

  ############
  ## Requires
  ############
  #############
  ## Constants
  #############
  ##################
  ## Public Actions
  ##################

  #show all products
  def index
    @products = Product.all
  end

  #show specific product
  def show
    #find the product
    @product = Product.find(params[:id])
  end

  #get request to show the form to create a new product
  def new
    @product = Product.new
  end

  #post requst to create the product
  def create
    @product = Product.new(params[:product])

    #if saved, show the list of products, else show the form with errors
    if @product.save
      return redirect_to [:admin, :products], notice: "Product created successfully."
    else
      return render action: :new
    end
  end

  #get request to show the form to edit the products
  def edit
    #find the product
    @product = Product.find(params[:id])
  end

  #put request to update the product
  def update
    #find the product
    @product = Product.find(params[:id])

    #if successfully updated, redirect to index, else show the form with error
    if @product.update_attributes(params[:product])
      return redirect_to [:admin, :products], notice: 'Product updated successfully.'
    else
      return render action: :edit
    end
  end

  #####################
  ## Protected Methods
  #####################
  protected

  ###################
  ## Private Methods
  ###################
  private

end
