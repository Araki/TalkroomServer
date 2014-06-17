class Inquiry < ActiveRecord::Base
  attr_accessible :address, :list_id, :platform, :id, :version, :manufacturer, :model, :body
end
