obfuscated_order = Epdq2::CreditCardObfuscator.new(order)
builder = Epdq2::Builder.new(obfuscated_order)
query = builder.query
raw_logger.info query