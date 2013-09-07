class Admin::SuppliersController < Admin::ApplicationController
  ###########
  ## Filters
  ###########
  ############
  ## Requires
  ############
  #############
  ## Constants
  #############
  ##################
  ## Public Actions
  ##################

  #show all suppliers
  def index
    @suppliers = Supplier.all
  end

  #show specific supplier
  def show
    #find the product
    @supplier = Supplier.find(params[:id])
  end

  #get request to show the form to create a new supplier
  def new
    @supplier = Supplier.new
  end

  #post requst to create the supplier
  def create
    @supplier = Supplier.new(params[:supplier])

    #if saved, show the list of suppliers, else show the form with errors
    if @supplier.save
      return redirect_to [:admin, :suppliers], notice: "Supplier created successfully."
    else
      return render action: :new
    end
  end

  #get request to show the form to edit the supplier
  def edit
    #find the supplier
    @supplier = Supplier.find(params[:id])
  end

  #put request to update the supplier
  def update
    #find the supplier
    @supplier = Supplier.find(params[:id])

    #if successfully updated, redirect to index, else show the form with error
    if @supplier.update_attributes(params[:supplier])
      return redirect_to [:admin, :suppliers], notice: 'Supplier updated successfully.'
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
