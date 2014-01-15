

class List < ActiveRecord::Base
  attr_accessible :name, :number
  
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
