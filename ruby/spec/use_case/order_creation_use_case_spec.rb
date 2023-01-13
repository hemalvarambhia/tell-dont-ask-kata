# frozen_string_literal: true

require_relative '../doubles/test_order_repository'
require_relative '../doubles/in_memory_product_catalog'

require 'use_case/order_creation_use_case'
require 'use_case/sell_item_request'
require 'use_case/sell_items_request'

require 'domain/product'
require 'domain/category'

RSpec.describe OrderCreationUseCase do
  let(:order_repository) { TestOrderRepository.new }
  let(:food) { Category.new(name: 'food', tax_percentage: 10.0) }

  let(:product_catalog) do
    InMemoryProductCatalog.new(
      [
        Product.new(name: 'salad', price: 3.56, category: food),
        Product.new(name: 'tomato', price: 4.65, category: food)
      ]
    )
  end

  let(:use_case) { OrderCreationUseCase.new(order_repository, product_catalog) }

  it 'sells multiple items' do
    salad_request = SellItemRequest.new(product_name: 'salad', quantity: 2)
    tomato_request = SellItemRequest.new(product_name: 'tomato', quantity: 3)

    request = SellItemsRequest.new(requests: [salad_request, tomato_request])

    use_case.run(request)

    inserted_order = order_repository.saved_order

    expect(inserted_order.status).to eq(OrderStatus::CREATED)
    expect(inserted_order.total).to eq(23.20)
    expect(inserted_order.tax).to eq(2.13)
    expect(inserted_order.currency).to eq('EUR')
    expect(inserted_order.items.count).to eq(2)

    salad = OrderItem.new(
      product: Product.new(name: 'salad', price: 3.56),
      quantity: 2,
      taxed_amount: 7.84,
      tax: 0.72
    )
    assert_equal(inserted_order.items[0], salad)

    expect(inserted_order.items[1].product.name).to eq('tomato')
    expect(inserted_order.items[1].product.price).to eq(4.65)
    expect(inserted_order.items[1].quantity).to eq(3)
    expect(inserted_order.items[1].taxed_amount).to eq(15.36)
    expect(inserted_order.items[1].tax).to eq(1.41)
    tomato = OrderItem.new(
      product: Product.new(name: 'tomato', price: 4.65),
      quantity: 3,
      taxed_amount: 15.36,
      tax: 1.41
    )
    assert_equal(inserted_order.items[1], tomato)
  end

  it 'cannot sell an unknown product' do
    unknown_product_request = SellItemRequest.new(product_name: 'unknown product', quantity: rand(1..5))
    request = SellItemsRequest.new(requests: [unknown_product_request])

    expect { use_case.run(request) }.to raise_error(described_class::UnknownProductError)
  end

  private

  def assert_equal(inserted_order, expected_item)
    expect(inserted_order.product.name).to eq(expected_item.product.name)
    expect(inserted_order.product.price).to eq(expected_item.product.price)
    expect(inserted_order.quantity).to eq(expected_item.quantity)
    expect(inserted_order.taxed_amount).to eq(expected_item.taxed_amount)
    expect(inserted_order.tax).to eq(expected_item.tax)
  end
end
