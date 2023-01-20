# frozen_string_literal: true

class OrderShipmentUseCase
  class OrderCannotBeShippedError < StandardError; end
  class OrderCannotBeShippedTwiceError < StandardError; end

  def initialize(order_repository, shipment_service)
    @order_repository = order_repository
    @shipment_service = shipment_service
  end

  # @param request [OrderShipmentRequest]
  def run(request)
    order = @order_repository.get_by_id(request.order_id)

    raise OrderCannotBeShippedError if order.unshippable?

    raise OrderCannotBeShippedTwiceError if order.shipped?

    @shipment_service.ship(order)

    order.ship!
    @order_repository.save(order)
  end
end
