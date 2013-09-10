class Supplier < ActiveRecord::Base
  attr_accessible :active, :contact_info, :name

  #############
  ## Constants
  #############
  ################
  ## Associations
  ################
  has_many :products

  #######################
  ## Attribute Accessors
  #######################
  ###############
  ## Validations
  ###############
  validates :name, presence: { message: "is required" } #, uniqueness: { case_sensitive: false, message: "should be unique" }
  validates :contact_info, presence: { message: "is required" }

  ##############
  ## Scopes
  ##############
  ##############
  ## Call Backs
  ##############
  before_validation :squish_fields

  ######################
  ## Virtual Attributes
  ######################
  #################
  ## Class Apis
  #################
  class << self
  end

  ######################
  ## Public Apis
  #####################
  #####################
  ## Protected Apis
  #####################
  protected

  #####################
  ## Private Apis
  #####################
  private
    #squish fields
    def squish_fields
      self.name = self.name.present? ? self.name.squish : nil
      self.contact_info = self.contact_info.present? ? self.contact_info.strip : nil
    end

end
