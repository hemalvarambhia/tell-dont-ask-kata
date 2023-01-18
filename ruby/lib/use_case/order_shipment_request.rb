# frozen_string_literal: true

class OrderShipmentRequest
  attr_accessor :order_id

  def initialize(order_id = nil)
    @order_id = order_id
  end
end
