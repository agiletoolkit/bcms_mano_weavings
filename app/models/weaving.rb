class Weaving < ActiveRecord::Base
  acts_as_content_block
  belongs_to :weaver
  belongs_to :weaving_type
  belongs_to :wool_type

  def add_to_google_cart_button_html
    '<div class="product"><input type="hidden" class="product-title" value="Weaving"><input type="hidden" class="product-price" value="' + selling_price.to_s + '"><div class="googlecart-add-button" tabindex="0" role="button" title="Add to cart"></div></div>'
  end
end
