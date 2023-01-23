# frozen_string_literal: true

require_relative '../domain/order'
require_relative '../domain/order_item'
require_relative '../domain/product'

class OrderCreationUseCase
  class UnknownProductError < StandardError; end

  def initialize(order_repository, product_catalog)
    @order_repository = order_repository
    @product_catalog = product_catalog
  end

  # @param request [SellItemsRequest]
  def run(request)
    order = Order.blank(id: nil, currency: 'EUR')

    request.each_item do |item|
      product = @product_catalog.get_by_name(item.product_name)

      raise UnknownProductError if product.nil?

      order_item = to_order_item(product, item)
      order << order_item
    end

    @order_repository.save(order)
  end

  private

  def to_order_item(product, item_request)
    OrderItem.new(
      product: product,
      quantity: item_request.quantity,
      tax: item_request.tax_amount(product),
      taxed_amount: item_request.taxed_amount(product)
    )
  end
end
