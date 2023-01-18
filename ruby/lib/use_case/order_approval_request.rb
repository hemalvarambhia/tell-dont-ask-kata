# frozen_string_literal: true

class OrderApprovalRequest
  attr_reader :order_id, :approved

  def initialize(order_id:, approved:)
    @order_id = order_id
    @approved = approved
  end
end
