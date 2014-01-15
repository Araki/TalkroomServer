# coding: utf-8

class ApplicationController < ActionController::Base  
  protect_from_forgery  
  helper_method :current_omniuser  
  
  private  
  def current_omniuser  
    @current_omniuser ||= List.find(session[:user_id]) if session[:user_id]  
  end

  #認証済みかどうかを判定するcheck_loginedフィルタを定義
  def check_logined
    if session[:user_id] then
      begin
        @usr = List.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        reset_session
      end
    end
    
    unless @usr
      logger.info('ログインできなかった')
      flash[:referer] = request.fullpath
      redirect_to :controller => 'welcome', :action => 'index'
    end
  end
  
end