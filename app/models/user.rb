class User < ActiveRecord::Base
  has_many :shared_lists
  has_many :lists, :through => :shared_lists

  has_secure_password
  validates :uid, :uniqueness => {:scope => :provider, :allow_nil => true}

  def username
    nickname || email
  end

  def self.login_from_omniauth(auth_hash)
    find_from_omniauth(auth_hash) || create_from_omniauth(auth_hash)
  end

  def self.find_from_omniauth(auth_hash)
    find_by(:uid => auth_hash[:uid], :provider => auth_hash[:provider])
  end

  def self.create_from_omniauth(auth_hash)
    create(:uid => auth_hash[:uid],
           :provider => auth_hash[:provider],
           :nickname => auth_hash[:info][:nickname],
           :password => SecureRandom.hex(10))
  end


end
