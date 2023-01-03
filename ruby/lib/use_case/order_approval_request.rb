# frozen_string_literal: true

class OrderApprovalRequest
  attr_accessor :order_id, :approved

  def initialize(order_id: nil)
    @order_id = order_id
  end
end
