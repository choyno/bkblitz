class Notifier < ActionMailer::Base
  default from: "from@example.com"
  default to: "contact@blitzgift.com"

  def new_contact(contact)
    @contact = contact
    mail(:to => "contact@blitzgift.com", :subject => contact.subject)
  end


end
