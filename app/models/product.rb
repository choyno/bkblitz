class Product < ActiveRecord::Base
  attr_accessible :description, :name, :retail_price, :wholesale_price, :supplier_id

  #############
  ## Constants
  #############
  ################
  ## Associations
  ################
  belongs_to :supplier

  #######################
  ## Attribute Accessors
  #######################
  ###############
  ## Validations
  ###############
  validates :name, presence: { message: "is required" } #, uniqueness: { case_sensitive: false, message: "should be unique" }
  validates :supplier, presence: { message: "is required" }
  validates :retail_price, presence: { message: "is required" } #, numericality: { greater_than_or_equal_to: 0.01 }
  validates :wholesale_price, presence: { message: "is required" } #, numericality: { greater_than_or_equal_to: 0.01 }
  validates :description, presence: { message: "is required" }

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
      self.name = self.name.present? ? self.name.strip : nil
      self.description = self.description.present? ? self.description.strip : nil
    end

end
