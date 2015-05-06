require 'mail'

module Datanauts::Mailer
  class Sender

    def initialize(config = {})
      raise ArgumentError, "You must supply a from domain" unless config[:from_domain]
      
      @config = {
        test_email: 'test@obdev.co.uk',
        test_domains: %w(obdev.co.uk osbornebrook.co.uk datanauts.co.uk)
      }.merge(config)
      
      @config[:from_address] ||= "noreply@#{@config[:from_domain]}"
    end

    def mail(message)
      unless ENV['RACK_ENV'] == 'production'
        user, domain = message[:to_address].split '@'
        message[:email] = @config[:test_email] unless @config[:test_domains].include? domain
      end

      from_name  = message[:from_name] || @config[:from_name]
      from_address = message[:from_address] || @config[:from_address]

      email = Mail.new do

        to message[:to_address]
        cc message[:cc] if message[:cc]

        from "#{from_name} <#{from_address}>"
        subject message[:subject]

      end

      email.html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body message[:body][:html]
      end

      email.text_part = Mail::Part.new do
        body message[:body][:text]
      end

      if ENV['RACK_ENV'] == 'local'
        # puts email.encoded
      else
        email.deliver! unless ENV["NO_MAIL"]
      end

    end
    
  end
end
