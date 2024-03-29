# coding: utf-8

class SessionsController < ApplicationController  
  
  def callback  
    #omniauth.auth環境変数を取得  
    auth = request.env["omniauth.auth"]  
    #omniuserモデルを検索  
    omniuser = List.find_by_channel_and_fb_uid(auth["provider"], auth["uid"])  
  
    if omniuser  
      #外部認証済みの場合、ログイン  
      session[:user_id] = omniuser.id  
      redirect_to user_root_url, :notice => "ログインしました。"  
    else  
      #外部認証していない場合、:provider,:uidを保存してから、ログインさせる  
      List.create_with_omniauth(auth)  
      omniuser = List.find_by_channel_and_fb_uid(auth["provider"], auth["uid"])  
      session[:user_id] = omniuser.id  
      redirect_to user_root_url, :notice => "#{auth["info"]["name"]}さんの#{auth["provider"]}アカウントで登録しました。"  
    end  
  end  
  
  def destroy  
    session[:user_id] = nil  
    redirect_to root_url, :notice => "ログアウトしました。"  
  end  
  
end