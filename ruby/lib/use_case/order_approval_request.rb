# frozen_string_literal: true

class OrderApprovalRequest
  attr_reader :order_id

  def initialize(order_id:, approved:)
    @order_id = order_id
    @approved = approved
  end

  def approved?
    @approved
  end
end
