class InquiryMailer < ActionMailer::Base
  default :from => "inquiry@talkroom.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inquiry_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm(mail, body)
    @address = mail
    @body = body
    
    #mail(:to => "araki@shiftage.jp", :subject => "お問い合わせ") do |format|
      #format.text { render :text => body }
    #end
    mail(:to => "araki@shiftage.jp", :subject => "お問い合わせ")
  end
end
