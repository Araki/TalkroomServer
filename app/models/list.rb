class List < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :password, :channel, :fb_uid, :fb_name, :nickname, :email, :age, :purpose, :area, :profile_image1, :profile_image2, :profile_image3, :profile, :tall, :blood, :style, :holiday, :alcohol, :cigarette, :salary, :point, :last_logined, :gender, :app_token
  
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
    
  #validates :nickname,
  #  :presence => true
  
  validates :email,
    :presence => true,
    #:uniqueness => true,
    :length => { :maximum => 50 },
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
    
  #validates :age,
  #  :presence => true
    
  #validates :purpose,
  #  :presence => true
    
  #validates :area,
  #  :presence => true
  
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
  
  #validates :point,
  #  :presence => true,
  #  :numericality => { :only_integer => true }
  
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
  
  #=====================
  #新規
  #=====================
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = List.where(:provider => auth.channel, :uid => auth.fb_uid).first
    unless user
      user = List.create(:nickname => auth.extra.raw_info.name,
                         :channel => auth.provider,
                         :fb_uid => auth.uid,
 #                          email:auth.info.email, #emailを取得したい場合は、migrationにemailを追加してください。
                         :password => Devise.friendly_token[0,20]
                          )
    end
    user
  end
  
  
  
  
end
