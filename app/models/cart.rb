class Cart < ActiveRecord::Base
  has_many :weavings
  has_one :order

  def total_price
    total = 0
    weavings.each do |weaving|
      total += weaving.selling_price
    end
    total
  end

  def total_price_in_cents
    (total_price * 100).to_i
  end
end
