
# TWO OPTIONS & EXAMPLES. . smtp or sendmail
# uncomment one or the other blocks

# config.action_mailer.delivery_method = :sendmail
# # Defaults to:
# # config.action_mailer.sendmail_settings = {
# #   location: '/usr/sbin/sendmail',
# #   arguments: '-i -t'
# # }
# config.action_mailer.perform_deliveries = true
# config.action_mailer.raise_delivery_errors = true
# config.action_mailer.default_options = {from: 'no-replay@example.com'}


# ----------------

 config.action_mailer.delivery_method = :sendmail
 # Defaults to:
 # config.action_mailer.sendmail_settings = {
 #   location: '/usr/sbin/sendmail',
 #   arguments: '-i -t'
 # }
 config.action_mailer.perform_deliveries = true
 config.action_mailer.raise_delivery_errors = true
 config.action_mailer.default_options = {from: 'no-replay@example.com'}
  
