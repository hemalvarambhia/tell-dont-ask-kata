# frozen_string_literal: true

class OrderShipmentRequest
  attr_reader :order_id

  def initialize(order_id)
    @order_id = order_id
  end
end
