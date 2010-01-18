class CartPortlet < Portlet
  def render
    @cart = Cart.current_cart(session)
    @weavings_in_cart = []
    if @cart && @cart.weavings
      @weavings_in_cart = @cart.weavings
      @post_url = GOOGLE_CHECKOUT_CONFIGURATION[:use_sandbox] ? "https://sandbox.google.com/checkout/" : "https://checkout.google.com/"
      @post_url += "api/checkout/v2/checkout/Merchant/#{GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id]}"

      cart_xml = @cart.google_checkout_cart_xml @cart.id
      @cart_xml_b64 = Base64.b64encode(cart_xml).chomp
      @signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, GOOGLE_CHECKOUT_CONFIGURATION[:merchant_key], cart_xml)).chomp

      # The arguments for image_submit_tag
      @img_src = google_checkout_button_image_src
      @params = {
        :name => "Google Checkout",
        :alt => "Fast checkout through Google",
        :height => 46,
        :width => 180
      }
    end
  end

  private
  # Create the img source for the google checkout button
  def google_checkout_button_image_src
    img_src = GOOGLE_CHECKOUT_CONFIGURATION[:use_sandbox] ?
      "http://sandbox.google.com/checkout/buttons/checkout.gif" :
      "https://checkout.google.com/buttons/checkout.gif"
    params = {
      :merchant_id => GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id],
      :w => 180,
      :h => 46,
      :style => "white",
      :variant => "text",
      :loc => "en_US"
    }.to_a.inject([]){|arr, p| arr << p.join('=')}.join('&')
    [img_src, params].join('?')
  end
end
