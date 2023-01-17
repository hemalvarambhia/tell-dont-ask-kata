# frozen_string_literal: true

require_relative '../domain/order'
require_relative '../domain/order_item'
require_relative '../domain/order_status'
require_relative '../domain/product'

class OrderCreationUseCase
  class UnknownProductError < StandardError; end

  def initialize(order_repository, product_catalog)
    @order_repository = order_repository
    @product_catalog = product_catalog
  end

  # @param request [SellItemsRequest]
  def run(request)
    order = Order.blank('EUR')

    request.requests.each do |item_request|
      product = @product_catalog.get_by_name(item_request.product_name)

      raise UnknownProductError if product.nil?

      taxed_amount =  item_request.taxed_amount(product)
      tax_amount = item_request.tax_amount(product)

      order_item = OrderItem.new(product: product, quantity: item_request.quantity, tax: tax_amount, taxed_amount: taxed_amount)
      order.items << order_item
      order.total += order_item.taxed_amount
      order.tax += order_item.tax
    end

    @order_repository.save(order)
  end
end
