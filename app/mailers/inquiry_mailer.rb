class InquiryMailer < ActionMailer::Base
  default :from => "inquiry@talkroom.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inquiry_mailer.sendmail_confirm.subject
  #

  def sendmail_confirm( id, platform, version, manufacturer, model, mail, body)
    subject = "お問い合わせ:#{format("%05d", id)}"
    @platform = platform
    @version = version
    @manufacturer = manufacturer
    @model = model
    @address = mail
    @body = body
    
    #mail(:to => "araki@shiftage.jp", :subject => "お問い合わせ") do |format|
      #format.text { render :text => body }
    #end
    mail(:to => "araki@shiftage.jp", :subject => subject)
  end
  
  
  
  def send_report( report_id, reported_id, platform, version, manufacturer, model, body)
    subject = "通報(被通報者:#{reported_id} FROM:#{report_id})"
    @platform = platform
    @version = version
    @manufacturer = manufacturer
    @model = model
    @body = body
    
    #mail(:to => "araki@shiftage.jp", :subject => "お問い合わせ") do |format|
      #format.text { render :text => body }
    #end
    mail(:to => "araki@shiftage.jp", :subject => subject)
  end
  
  
end
