# frozen_string_literal: true

require 'use_case/order_shipment_use_case'
require 'use_case/order_shipment_request'

require 'domain/order'

require_relative '../doubles/test_shipment_service'

RSpec.describe OrderShipmentUseCase do
  let(:order_repository) { TestOrderRepository.new }
  let(:shipment_service) { TestShipmentService.new }
  let(:use_case) { OrderShipmentUseCase.new(order_repository, shipment_service) }
  let(:request) { OrderShipmentRequest.new(initial_order.id) }

  let(:initial_order) { Order.new(id: nil, status: '', total: 0.0, tax: 0.0, currency: 'EUR', items: []) }

  before { order_repository.add_order(initial_order) }

  it 'ships approved orders' do
    initial_order.approve!

    use_case.run(request)

    expect(order_repository.saved_order).to be_shipped
    expect(shipment_service.shipped_order).to eq(initial_order)
  end

  it 'cannot ship created orders' do
    initial_order.create!

    expect { use_case.run(request) }.to raise_error(described_class::OrderCannotBeShippedError)

    expect(order_repository.saved_order).to be_nil
    expect(shipment_service.shipped_order).to be_nil
  end

  it 'cannot ship rejected orders' do
    initial_order.reject!

    expect { use_case.run(request) }.to raise_error(described_class::OrderCannotBeShippedError)

    expect(order_repository.saved_order).to be_nil
    expect(shipment_service.shipped_order).to be_nil
  end

  it 'cannot ship orders that have been shipped already' do
    initial_order.ship!

    expect { use_case.run(request) }.to raise_error(described_class::OrderCannotBeShippedTwiceError)

    expect(order_repository.saved_order).to be_nil
    expect(shipment_service.shipped_order).to be_nil
  end
end
