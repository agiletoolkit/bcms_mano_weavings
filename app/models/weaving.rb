class Weaving < ActiveRecord::Base
  acts_as_content_block
  validates_presence_of :item_number
  validates_uniqueness_of :item_number
  validates_presence_of :summary_description
  validates_presence_of :description
  validates_each :weaving_type do |record, attr, value|
    if record.weaving_type
      record.errors.add attr, 'must be published' unless record.weaving_type.published?
    else
      record.errors.add attr, 'must be specified'
    end
  end
  validates_each :weaver do |record, attr, value|
    if record.weaver
      record.errors.add attr, 'must be published' unless record.weaver.published?
    else
      record.errors.add attr, 'must be specified'
    end
  end
  validates_each :wool_type do |record, attr, value|
    if record.wool_type
      record.errors.add attr, 'must be published' unless record.wool_type.published?
    else
      record.errors.add attr, 'must be specified'
    end
  end
  belongs_to :weaver
  belongs_to :weaving_type
  belongs_to :wool_type
  belongs_to :cart
  has_many :weaving_photos

  # Weavings should be identified by their item number but BrowserCMS is hell bent on using :name
  # Created this so this module can refer to item_number and name will just contain a copy of item_number
  # so things like searching in the content library work as expected.
  # This module should not use the field weaving.name (use Weaving.item_number instead)
  def item_number=(new_item_number)
    write_attribute(:name, new_item_number)
    write_attribute(:item_number, new_item_number)
  end

  def self.columns_for_index
    [ {:label => "Item Number", :method => :item_number, :order => "item_number" } ]
  end

  def self.default_order
    "item_number asc"
  end
end
