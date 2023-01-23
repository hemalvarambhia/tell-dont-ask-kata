describe 'Preparing an order' do
  it 'computes the tax and total amount to be paid' do
    food = Category.new(name: 'food', tax_percentage: 10.0)
    items = [
      OrderItem.new(
        product: Product.new(name: 'salad', price: 3.56, category: food),
        quantity: 2,
        taxed_amount: 7.84,
        tax: 0.72
      ),
      OrderItem.new(
        product: Product.new(name: 'tomato', price: 4.65, category: food),
        quantity: 3,
        taxed_amount: 15.36,
        tax: 1.41
      )
    ]
    order = Order.with(id: rand(1..10), currency: 'EUR', status: Order::CREATED, items: items)

    expect(order.tax).to eq(0.72 + 1.41)
    expect(order.total).to eq(7.84 + 15.36)
  end

  it 'computes the tax and taxed amounts of a blank order'
end