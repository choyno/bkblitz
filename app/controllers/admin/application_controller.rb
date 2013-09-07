class Admin::ApplicationController < ApplicationController
  ###########
  ## Filters
  ###########
  before_filter :authorize

  ############
  ## Requires
  ############
  #############
  ## Constants
  #############
  ##################
  ## Public Actions
  ##################

  #####################
  ## Protected Methods
  #####################
  protected

    #authorize the users
    def authorize
      authenticate_or_request_with_http_basic do |username, password|
        username == "admin" && password == "blitzgift"
      end
    end

    #authorize the users for admin/ paths only
    def authorize_admin_path_only
      @show_to_admin_only = false
      if request.path =~ /admin/
        authorize
        @show_to_admin_only = true
      end
    end


  ###################
  ## Private Methods
  ###################
  private

end
