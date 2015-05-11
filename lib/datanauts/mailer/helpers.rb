module Datanauts::Mailer::Helpers

  def mail(options)
    Worker.perform_async(options)
  end
end
