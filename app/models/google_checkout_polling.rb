class GoogleCheckoutPolling < ActiveRecord::Base
  # Implement the same behavior as acts_as_singleton gem provided
  def self.instance
    if GoogleCheckoutPolling.exists? 1
      GoogleCheckoutPolling.find 1
    else
      GoogleCheckoutPolling.new
    end
  end
end
