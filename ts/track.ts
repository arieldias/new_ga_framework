@func XMLNode.track(Text %category, Text %action) {
  attributes(
    data-track:          "event",
    data-track-category: %category,
    data-track-action:   %action
  )
}
@func XMLNode.track(Text %category, Text %action, Text %label) {
  track(%category, %action)
  attributes(
    data-track-label: %label
  )
}

@func XMLNode.track(Text %category, Text %action, Text %label, Text %value) {
  track(%category, %action, %label)
  attributes(
    data-track-value: %value
  )
}

@func XMLNode.track$(Text %xpath, Text %category, Text %action) {
  $(%xpath) {
    track(%category, %action)
    yield()
  }
}
@func XMLNode.track$(Text %xpath, Text %category, Text %action, Text %label) {
  $(%xpath) {
    track(%category, %action, %label)
    yield()
  }
}

@func XMLNode.track$(Text %xpath, Text %category, Text %action, Text %label, Text %value) {
  $(%xpath) {
    track(%category, %action, %label, %value)
    yield()
  }
}

@func XMLNode.setup_page(Text %class) {
  $("./body") {
    add_class(%class)
    yield()
  }
}

@func XMLNode.setup_page(Text %class, Text %value, Text %index) {
  $("./body") {
    add_class(%class)
    attributes(
      data-index: %index,
      data-value: %value
    )
    yield()
  }
}

@func XMLNode.setup_page(Text %class, Text %value, Text %index, Text %opt_scope) {
  $("./body") {
    add_class(%class)
    attributes(
      data-index:     %index,
      data-value:     %value,
      data-opt-scope: %opt_scope

    )
    yield()
  }
}

########################################
# eCommerce
# Let's get this done.
########################################
@func XMLNode.ecommerce_set_id(Text %xpath) {
  $id = fetch(%xpath)
  $("/html/body",
    data-track-id: $id
  )
}

@func XMLNode.ecommerce_set_store_name(Text %xpath) {
  $store = fetch(%xpath)
  $("/html/body",
    data-track-store-name: $store
  )
}

@func XMLNode.ecommerce_set_total(Text %xpath) {
  $total = fetch(%xpath)
  $("/html/body",
    data-track-total: $total
  )
}

@func XMLNode.ecommerce_set_shippingText %xpath) {
  $shipping = fetch(%xpath)
  $("/html/body",
    data-track-shipping: $shipping
  )
}

@func XMLNode.ecommerce_set_sales_tax(Text %xpath) {
  $sales_tax = fetch(%xpath)
  $("/html/body",
    data-track-sales-tax: $sales_tax
  )
}

@func XMLNode.item$(Text %xpath) {
  $(%xpath,
    data-track-item: "item"
  ) {
    yield()
  }
}

@func XMLNode.set_item_id(Text %id) {
  attributes(
    data-track-id: %id
  )
}

@func XMLNode.set_item_name(Text %name) {
  attributes(
    data-track-name: %name
  )
}

@func XMLNode.set_item_sku(Text %sku) {
  attributes(
    data-track-sku: %sku
  )
}

@func XMLNode.set_item_category(Text %category) {
  attributes(
    data-track-category: %category
  )
}

@func XMLNode.set_item_price(Text %price) {
  attributes(
    data-track-price: %price
  )
}

@func XMLNode.set_item_quantity(Text %quantity) {
  attributes(
    data-track-quantity: %quantity
  )
}

@func XMLNode.set_item_id$(Text %xpath, Text %id) {
  $(%xpath) {
    set_item_id(%id)
    yield()
  }
}

@func XMLNode.set_item_name$(Text %xpath, Text %name) {
  $(%xpath) {
    set_item_name(%name)
    yield()
  }
}

@func XMLNode.set_item_sku$(Text %xpath, Text %sku) {
  $(%xpath) {
    set_item_sku(%sku)
    yield()
  }
}

@func XMLNode.set_item_category$(Text %xpath, Text %category) {
  $(%xpath) {
    set_item_category(%category)
    yield()
  }
}

@func XMLNode.set_item_price$(Text %xpath, Text %price) {
  $(%xpath) {
    set_item_price(%price)
    yield()
  }
}

@func XMLNode.set_item_quantity$(Text %xpath, Text %quantity) {
  $(%xpath) {
    set_item_quantity(%quantity)
    yield()
  }
}





