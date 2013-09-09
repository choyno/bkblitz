class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if @contact.save
      Notifier.new_contact(@contact).deliver
      redirect_to(root_path, :notice => "Email was successfully sent.")
    else
      flash.now.alert = "Please fill email and body."
      render :new
    end
  end
end
