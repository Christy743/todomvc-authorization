class SharedList < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  PERMISSIONS = {
    :destroy => 0,
    :edit => 10,
    :view => 100
  }

  def self.permissable(*args)
    args.each do |action|
      # action #=> :view
      define_method "#{action}able?" do
        self.permission <= PERMISSIONS[action]
      end
    end
  end

  permissable :view, :edit, :destroy



  # def viewable?
  #   self.permission <= PERMISSIONS[:guest]
  # end
  #
  # def editable?
  #   self.permission <= PERMISSIONS[:collaborator]
  # end
  #
  # def destroyable?
  #   self.permission <= PERMISSIONS[:owner]
  # end
end
