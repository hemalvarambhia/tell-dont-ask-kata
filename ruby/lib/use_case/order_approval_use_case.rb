# frozen_string_literal: true

require_relative '../domain/order_status'

class OrderApprovalUseCase
  class ShippedOrdersCannotBeChangedError < StandardError; end
  class RejectedOrderCannotBeApprovedError < StandardError; end
  class ApprovedOrderCannotBeRejectedError < StandardError; end

  def initialize(order_repository)
    @order_repository = order_repository
  end

  # @param request [OrderApprovalRequest]
  def run(request)
    order = @order_repository.get_by_id(request.order_id)

    raise ShippedOrdersCannotBeChangedError if order.shipped?

    raise RejectedOrderCannotBeApprovedError if request.approved && order.rejected?

    raise ApprovedOrderCannotBeRejectedError if !request.approved && order.approved?

    order.status = request.approved ? OrderStatus::APPROVED : OrderStatus::REJECTED

    @order_repository.save(order)
  end
end
