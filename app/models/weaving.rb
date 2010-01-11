class Weaving < ActiveRecord::Base
  acts_as_content_block
  belongs_to :weaver
  belongs_to :weaving_type
  belongs_to :wool_type
  belongs_to :cart
end
