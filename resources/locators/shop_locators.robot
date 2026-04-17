*** Variables ***
# shop_locators.robot
#
# Element locators for the Products (/products), Cart (/cart),
# and Checkout (/checkout) pages.
#
# All locators were captured via automated headless DOM inspection
# of the live site, ensuring each selector maps to a real element.


# =============================================================================
# PRODUCTS PAGE — /products
# =============================================================================

# Page identity — confirms the All Products page has fully rendered
${PRODUCTS_PAGE_TITLE}                  css:[data-testid='all-products-title']

# Search input — allows filtering products by keyword
${PRODUCTS_SEARCH_INPUT}                css:[data-testid='all-products-search-input']

# Filter toggle — button that opens/closes the filter sidebar panel
${PRODUCTS_FILTER_TOGGLE_BTN}           css:[data-testid='all-products-filter-toggle']

# Results label — displays the count of visible products (e.g., "Showing 14 products")
# Used to assert that a filter had an effect on the product list
${PRODUCTS_RESULTS_COUNT}               css:[data-testid='all-products-results-count']

# --- Filter Panel (visible after clicking PRODUCTS_FILTER_TOGGLE_BTN) ---

# Category label — section heading for the category dropdown
${FILTER_CATEGORY_LABEL}                css:[data-testid='all-products-category-label']

# Category dropdown — <select> element with options: "all", "uncategorized"
# Note: The site currently has only two category values. "uncategorized" is
# used in tests to demonstrate filter interaction without hiding all products.
${FILTER_CATEGORY_SELECT}               css:[data-testid='all-products-category-select']

# Price range label — displays the current min/max price selection
${FILTER_PRICE_RANGE_LABEL}             css:[data-testid='all-products-price-range-label']

# Price range sliders — type="range" inputs for min and max price bounds
${FILTER_PRICE_MIN_SLIDER}              css:[data-testid='all-products-price-range-input-0']
${FILTER_PRICE_MAX_SLIDER}              css:[data-testid='all-products-price-range-input-1']

# Reset button — clears all active filters and restores the full product list
${FILTER_RESET_BTN}                     css:[data-testid='all-products-reset-filters-button']

# --- Product Cards ---
# The site renders repeated elements with the same data-testid value.
# These variables point to the shared selector; the keywords use
# Get WebElements to retrieve the full list and interact with index [0].
# Why not use :nth-of-type(1)?
#   :nth-of-type selects by element tag position among siblings, not by
#   attribute. For repeated <button> or <h2> elements with the same
#   data-testid across different parent nodes, it resolves unreliably.
#   Get WebElements + index [0] is the correct Robot Framework approach.

# Shared CSS selector for all product name headings on the listing page
${ALL_PRODUCTS_NAME_SELECTOR}           css:[data-testid='all-products-header']

# Shared CSS selector for all product prices on the listing page
${ALL_PRODUCTS_PRICE_SELECTOR}          css:[data-testid='all-products-price']

# Shared CSS selector for all "Add to Cart" buttons on the listing page
${ALL_PRODUCTS_CART_BTN_SELECTOR}       css:[data-testid='all-products-cart-button']


# =============================================================================
# CART PAGE — /cart
# =============================================================================

# Page identity — confirms the dedicated cart page has loaded
${CART_PAGE_TITLE}                      css:[data-testid='cart-title']

# Cart item details
${CART_PRODUCT_NAME}                    css:[data-testid='cart-product-header']
${CART_ITEM_PRICE}                      css:[data-testid='cart-price']
${CART_ITEM_QTY}                        css:[data-testid='cart-quantity']
${CART_QTY_INCREASE_BTN}                css:[data-testid='cart-increment-button']
${CART_QTY_DECREASE_BTN}                css:[data-testid='cart-decrement-button']
${CART_ITEM_SUBTOTAL}                   css:[data-testid='cart-subtotal']
${CART_ITEM_DELETE_BTN}                 css:[data-testid='cart-delete-button']

# Order summary section
${CART_ORDER_SUMMARY_TITLE}             css:[data-testid='cart-order-summary-title']
${CART_TOTAL_VALUE}                     css:[data-testid='cart-order-summary-total-value']
${CART_SHIPPING_VALUE}                  css:[data-testid='cart-order-summary-shipping-value']

# Cart action buttons
${CART_CHECKOUT_BTN}                    css:[data-testid='cart-checkout-button']
${CART_CONTINUE_SHOPPING_BTN}           css:[data-testid='cart-continue-shopping-button']

# Empty cart state — visible when no items have been added
${CART_EMPTY_TITLE}                     css:[data-testid='cart-empty-title']


# =============================================================================
# CHECKOUT PAGE — /checkout
# =============================================================================
# Note: /checkout requires authentication. Unauthenticated access redirects
# to /login. Tests must complete signup + login before reaching this page.

# Page identity — confirms the checkout page has loaded (not a login redirect)
${CHECKOUT_PAGE_TITLE}                  css:[data-testid='checkout-title']

# --- Shipping Address Section ---
# Users must fill and save their address before selecting a payment method.

${CHECKOUT_SHIPPING_SECTION_TITLE}      css:[data-testid='checkout-shipping-address-title']
${CHECKOUT_FIRSTNAME_INPUT}             css:[data-testid='checkout-first-name-input']
${CHECKOUT_EMAIL_INPUT}                 css:[data-testid='checkout-email-input']
${CHECKOUT_STREET_INPUT}                css:[data-testid='checkout-street-input']
${CHECKOUT_CITY_INPUT}                  css:[data-testid='checkout-city-input']
${CHECKOUT_STATE_INPUT}                 css:[data-testid='checkout-state-input']
${CHECKOUT_ZIP_CODE_INPUT}              css:[data-testid='checkout-zip-code-input']
${CHECKOUT_COUNTRY_INPUT}               css:[data-testid='checkout-country-input']

# Saves the entered address before allowing payment method selection
${CHECKOUT_SAVE_ADDRESS_BTN}            css:[data-testid='checkout-save-address-button']

# --- Payment Method Section ---
# Four payment options are available. Each is a toggle button.

${CHECKOUT_PAYMENT_SECTION_TITLE}       css:[data-testid='checkout-payment-method-title']
${CHECKOUT_PAY_CREDIT_CARD_BTN}         css:[data-testid='checkout-credit-card-button']
${CHECKOUT_PAY_DEBIT_CARD_BTN}          css:[data-testid='checkout-debit-card-button']
${CHECKOUT_PAY_NET_BANKING_BTN}         css:[data-testid='checkout-netbanking-button']
${CHECKOUT_PAY_COD_BTN}                 css:[data-testid='checkout-cod-button']

# --- Credit/Debit Card Fields ---
# These fields appear only when Credit Card or Debit Card is selected.
# Not used in current tests since Cash on Delivery is selected instead.

${CHECKOUT_CARD_NUMBER_INPUT}           css:[data-testid='checkout-card-number-input']
${CHECKOUT_CARDHOLDER_NAME_INPUT}       css:[data-testid='checkout-cardholder-name-input']
${CHECKOUT_EXPIRY_MONTH_INPUT}          css:[data-testid='checkout-expiration-date-month-input']
${CHECKOUT_EXPIRY_YEAR_INPUT}           css:[data-testid='checkout-expiration-date-year-input']
${CHECKOUT_CVV_INPUT}                   css:[data-testid='checkout-cvv-input']

# --- Order Summary & Final Actions ---

${CHECKOUT_ORDER_SUMMARY_TITLE}         css:[data-testid='checkout-order-summary-title']
${CHECKOUT_ORDER_TOTAL_VALUE}           css:[data-testid='checkout-total-value']

# Final submit button — places the order and triggers a redirect on success
${CHECKOUT_PLACE_ORDER_BTN}             css:[data-testid='checkout-place-order-button']

# Back navigation — returns the user to /cart without losing cart contents
${CHECKOUT_BACK_TO_CART_BTN}            css:[data-testid='checkout-back-to-cart-button']
