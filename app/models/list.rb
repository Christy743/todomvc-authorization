class List < ActiveRecord::Base
  validates :name, :length => {:minimum => 3}

  has_many :items
  has_many :shared_lists
  has_many :users, :through => :shared_lists

  accepts_nested_attributes_for :items

  def self.permissions_for(*args)
    association = args[0]
    methods = args[1..-1]

    # assocation #> :shared_lists
    # methods #=> [:edit, :view]

    # end defining 2 methods whose names are the elements in methods array
    methods.each do |method_name|
      define_method "#{method_name}able_by?" do |user|
        assoc = self.send(association).find_by(:user => user)#=> nil
        if !assoc
          return false
        else
          assoc.send("#{method_name}able?") # 10 is the minimum permission for viewing
        end
      end
    end
  end

  # Dynamic Definition
  permissions_for :shared_lists, :edit, :view, :destroy
  # somehow calling permission_for must build 2 methods, editable_by, viewaable_?




  # def editable_by?(user)
  #   shared_list = self.shared_lists.find_by(:user => user)#=> nil
  #   if !shared_list
  #     return false
  #   else
  #     shared_list.editable? # 10 is the minimum permission for viewing
  #   end
  # end
  #
  # def viewable_by?(user)
  #   # how do I answer this question?
  #   # self #=> #<List: 7>
  #   # user #=> #<User: 3>
  #
  #   # who has the answer to this question?
  #   # somehow from our controller, with only access to the user and the object
  #   # we must end up on a shared_list
  #   shared_list = self.shared_lists.find_by(:user => user)#=> nil
  #   if !shared_list
  #     return false
  #   else
  #     shared_list.viewable? # 10 is the minimum permission for viewing
  #   end
  #
  #   #<SharedList id: 3, user_id: 3, list_id: 7, permission: 0>
  # end

end
