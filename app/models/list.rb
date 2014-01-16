

class List < ActiveRecord::Base
  attr_accessible :channel, :fb_uid, :fb_name, :nickname, :email, :age, :purpose, :area, :profile_image1, :profile_image2, :profile_image3, :profile, :tall, :blood, :style, :holiday, :alcohol, :cigarette, :salary, :point
  
  #==========
  #アソシエーションの設定
  #==========
  has_many :messages
  has_many :visits
  
  
  #==========
  #バリデーションの設定
  #==========
  validates :channel,
    :presence => true
    
  # validates fb_uid,
    
  # validates :fb_name,
    
  validates :nickname,
    :presence => true
  
  validates :email,
    :presence => true,
    :uniqueness => true,
    :length => { :maximum => 50 },
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
    
  validates :age,
    :presence => true
    
  validates :purpose,
    :presence => true
    
  validates :area,
    :presence => true
  
  validates :profile_image1,
    :presence => true
    
  # validates :profile_image2,
    
  # validates :profile_image3,
    
  validates :profile,
    :length => { :maximum => 140 }
    
  # validates :tall,
  
  # validates :blood,
  
  # validates :style,
  
  # validates :holiday,
  
  # validates :alcohol,
  
  # validates :cigarette,
  
  # validates :salary,
  
  validates :point,
    :presence => true,
    :numericality => { :only_integer => true }
  
  #==========
  #LISTテーブルへのユーザー情報登録
  #==========
  
  def self.create_with_omniauth(auth)
    create! do |list|
      list.channel = auth["provider"]
      list.fb_uid = auth["uid"]
      
      if list.channel == "facebook"
        list.fb_name = auth["info"]["name"]
        list.profile_image1 = auth["info"]["image"]
        list.email = auth["info"]["email"]
      else
        list.fb_name = auth["info"]["nickname"]
      end
    end
  end
end
