class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def new_contact(contact)
    @contact = contact
    mail(:subject => contact.subject)
  end


end
