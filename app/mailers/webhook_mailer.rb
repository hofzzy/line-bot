# frozen_string_literal: true

class WebhookMailer < ApplicationMailer
  def message_read(message)
    mail to: ENV['DEVELOPER_MAIL'],
         from: "\"#{ENV['LINE_CHANNEL_NAME']}\" <#{ENV['LINE_CHANNEL_MAIL']}>",
         subject: message.to_s
  end
end
