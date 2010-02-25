class WeavingPhoto < ActiveRecord::Base
  acts_as_content_block :belongs_to_attachment => true
  belongs_to :weaving
end
