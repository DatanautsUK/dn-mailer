require 'mail'

module Datanauts
  module Delivery



    def mail(opts = {})
      test_email   = ENV['test_email'] || CONFIG['test_email'] || 'test@obdev.co.uk'
      test_domains = CONFIG['test_domains'] || %w(obdev.co.uk osbornebrook.co.uk datanauts.co.uk)

      unless ENV['RACK_ENV'] == 'production'
        user, domain = opts[:email].split '@'
        opts[:email] = test_email unless test_domains.include? domain
      end

      from_name  = opts[:from_name]  || CONFIG['company_name']
      from_email = opts[:from_email] || CONFIG["contact_email"] || "noreply@#{CONFIG['company_domain']}"

      email = Mail.new do

        to opts[:email]
        cc opts[:cc] if opts[:cc]

        from "#{from_name} <#{from_email}>"
        subject opts[:subject]

      end

      html_body = if opts[:body].blank?
        mail_haml("mail/#{opts[:template]}", :locals => opts[:locals])
      else
        opts[:body]
      end

      html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body html_body
      end

      text_part = Mail::Part.new do
        body html_body.strip_html
      end

      if opts[:attachments].is_a? Array

        inner_mail = Mail.new
        inner_mail.html_part = html_part
        inner_mail.text_part = text_part

        opts[:attachments].each do |attachment|
          # this will accept a string (/path/to/file.pdf) or a hash ({:filename => "blah.pdf", :content => File.read('/path/to/file.pdf')})
          email.add_file attachment
        end

        email.add_part inner_mail

      else

        email.html_part = html_part
        email.text_part = text_part

      end

      if ENV['RACK_ENV'] == 'local'
        puts email.encoded
      else
        email.deliver! unless ENV["NO_MAIL"]
      end

    end
    
  end
end
