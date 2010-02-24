class WeavingType < ActiveRecord::Base
  acts_as_content_block :belongs_to_attachment => true
  has_many :weavings
  belongs_to :user
  validates_presence_of :name
  validates_uniqueness_of :name
end
