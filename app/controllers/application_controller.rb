# coding: utf-8

class ApplicationController < ActionController::Base  
  protect_from_forgery  
  helper_method :current_omniuser  
  
  private  
  def current_omniuser  
    @current_omniuser ||= List.find(session[:user_id]) if session[:user_id]  
  end  
end