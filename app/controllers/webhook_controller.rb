# frozen_string_literal: true

require 'line/bot'

class WebhookController < ApplicationController
  def callback
    head 400 unless client.validate_signature(request_body, signature)

    client.parse_events_from(request_body).each do |event|
      case event
      when Line::Bot::Event::Postback
        WebhookMailer.message_read(event['postback']['data']).deliver_now
      end
    end

    head 200
  end

  private

  def request_body
    request.body.read
  end

  def signature
    request.env['HTTP_X_LINE_SIGNATURE']
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
