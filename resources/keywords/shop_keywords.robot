*** Settings ***
# shop_keywords.robot
#
# Keywords covering the shopping flow: navigating to the products page,
# applying filters, adding items to the cart, and completing checkout.
#
# Why separate from auth_keywords?
#   Shopping logic is independent of authentication logic. Keeping them
#   separate makes each file focused, easier to read, and reduces the
#   risk of unintended side effects when one area changes.

Library     SeleniumLibrary
Resource    ../variables.robot
Resource    ../locators/home_locators.robot
Resource    ../locators/shop_locators.robot
Resource    common_keywords.robot


*** Keywords ***
Click Shop Now On Homepage
    # Navigates to the homepage first to ensure a consistent starting state,
    # then clicks the "Shop Now" button in the hero section.
    # Why navigate to homepage instead of assuming we're already there?
    #   Tests may be run in any order. Explicitly navigating avoids failures
    #   caused by leftover state from the previous test case.
    Navigate To Page    ${BASE_URL}
    Wait And Click Element    ${HOME_HERO_SHOP_NOW_BTN}
    Wait Until Page Is Loaded

Verify Navigated To Products Page
    # Confirms the browser is on /products and the page title is visible.
    # Two assertions are used: URL check confirms routing, element check
    # confirms the React component has fully mounted.
    Wait Until Location Contains    /products    timeout=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible   ${PRODUCTS_PAGE_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Log    Successfully navigated to the All Products page

Open Filter Panel
    # Clicks the "Filters" toggle button to reveal the filter sidebar.
    # The panel is hidden by default to save screen space on the products page.
    # We wait for the category dropdown to appear as confirmation that the
    # panel has fully expanded before interacting with its controls.
    Wait And Click Element    ${PRODUCTS_FILTER_TOGGLE_BTN}
    Wait Until Element Is Visible    ${FILTER_CATEGORY_SELECT}    timeout=${SELENIUM_TIMEOUT}
    Log    Filter panel is open

Select Category Filter
    # Selects a category from the dropdown by its visible label (e.g., "All"),
    # then closes the filter panel by clicking the toggle again.
    # Why Select From List By Label instead of Select From List By Value?
    #   The argument passed is the visible text "All", not the underlying <option>
    #   value attribute "all". By Label matches what the user sees; by Value would
    #   require passing the lowercase internal value and is more brittle when the
    #   site changes option values without changing visible labels.
    # Why close the panel after selection?
    #   The filter sidebar overlaps the product list on smaller viewports.
    #   Leaving it open causes "element not visible" failures when trying
    #   to interact with the cart buttons behind it.
    # Sleep 2s allows the product list to fully re-render after the selection.
    [Arguments]    ${category_label}=All
    Wait Until Element Is Visible    ${FILTER_CATEGORY_SELECT}    timeout=${SELENIUM_TIMEOUT}
    Select From List By Label    ${FILTER_CATEGORY_SELECT}    ${category_label}
    Sleep    2s
    # Close the filter panel so it no longer overlaps the product list
    Wait And Click Element    ${PRODUCTS_FILTER_TOGGLE_BTN}
    Sleep    1s
    Log    Category filter applied: ${category_label}

Get Product Count From Results Label
    # Reads the results label (e.g., "Showing 14 products") and returns it
    # as a string for logging purposes. Used to confirm the filter had an effect.
    ${count_text}=    Get Text    ${PRODUCTS_RESULTS_COUNT}
    Log    Products visible after filter: ${count_text}
    RETURN    ${count_text}

Get First Product Name
    # Retrieves all product name elements via Get WebElements and reads the
    # text of the first item (index 0). Stored as a Suite Variable so
    # downstream keywords can reference it without repeating the DOM lookup.
    # Why Get WebElements instead of a single locator with :nth-of-type(1)?
    #   :nth-of-type is based on tag position among siblings, not attribute
    #   matching. For repeated elements across different parent nodes it is
    #   unreliable. Get WebElements + index access is the correct approach.
    ${elements}=    Get WebElements    ${ALL_PRODUCTS_NAME_SELECTOR}
    ${name}=    Get Text    ${elements}[0]
    Set Suite Variable    ${SELECTED_PRODUCT_NAME}    ${name}
    Log    Selected product: ${name}
    RETURN    ${name}

Add First Product To Cart
    # Retrieves all "Add to Cart" buttons via Get WebElements and clicks
    # the first one (index 0), adding the top product to the cart.
    #
    # Why add from the listing page instead of the product detail page?
    #   During DOM inspection the product detail page's add-to-cart button
    #   did not expose a data-testid attribute in headless mode, making it
    #   unreliable. The listing page cart button is stable and achieves the
    #   same result.
    # Sleep 1.5s allows the React cart state to update before navigating away.
    Wait Until Element Is Visible    ${ALL_PRODUCTS_CART_BTN_SELECTOR}    timeout=${SELENIUM_TIMEOUT}
    ${product_name}=    Get First Product Name
    ${cart_buttons}=    Get WebElements    ${ALL_PRODUCTS_CART_BTN_SELECTOR}
    Click Element    ${cart_buttons}[0]
    Sleep    1.5s
    Log    '${product_name}' added to cart

Add Product To Cart By Name
    # Finds a specific product by its visible name on the listing page and clicks
    # its corresponding "Add to Cart" button.
    #
    # Why match by index instead of a name-based CSS selector?
    #   The product name and cart button are siblings inside the same card, but
    #   there is no direct CSS relationship between a specific name and its button.
    #   Get WebElements returns both lists in DOM order, so name[i] and button[i]
    #   always correspond to the same product card. Iterating by index is reliable.
    #
    # Why Set Suite Variable for SELECTED_PRODUCT_NAME?
    #   The order confirmation keyword logs the product name. Storing it as a
    #   Suite Variable avoids passing it through every keyword argument chain.
    [Arguments]    ${target_name}
    Wait Until Element Is Visible    ${ALL_PRODUCTS_NAME_SELECTOR}    timeout=${SELENIUM_TIMEOUT}
    ${name_elements}=    Get WebElements    ${ALL_PRODUCTS_NAME_SELECTOR}
    ${cart_buttons}=     Get WebElements    ${ALL_PRODUCTS_CART_BTN_SELECTOR}
    ${count}=            Get Length    ${name_elements}
    FOR    ${i}    IN RANGE    ${count}
        ${name}=    Get Text    ${name_elements}[${i}]
        IF    '${name}' == '${target_name}'
            Set Suite Variable    ${SELECTED_PRODUCT_NAME}    ${name}
            Click Element    ${cart_buttons}[${i}]
            Sleep    1.5s
            Log    '${name}' added to cart
            RETURN
        END
    END
    Fail    Product named '${target_name}' was not found on the current page

Open Cart Page
    # Navigates directly to /cart rather than clicking the cart icon.
    # Why direct navigation?
    #   The cart icon opens a side drawer, not a full page. Direct navigation
    #   to /cart loads the dedicated cart page with checkout controls.
    Navigate To Page    ${CART_URL}
    Wait Until Element Is Visible    ${CART_PAGE_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Log    Cart page opened

Verify Product Is In Cart
    # Confirms at least one product is displayed in the cart by checking
    # that the product name element is visible. This guards against a
    # scenario where the add-to-cart action silently failed.
    Wait Until Element Is Visible    ${CART_PRODUCT_NAME}    timeout=${SELENIUM_TIMEOUT}
    ${cart_product}=    Get Text    ${CART_PRODUCT_NAME}
    Log    Product in cart: ${cart_product}

Proceed To Checkout From Cart
    # Clicks the "Checkout" button on the cart page and waits for the browser
    # to redirect to /checkout. Also confirms the checkout page title is
    # visible to ensure the authenticated checkout page loaded (not a login redirect).
    Wait And Click Element    ${CART_CHECKOUT_BTN}
    Wait Until Location Contains    /checkout    timeout=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible   ${CHECKOUT_PAGE_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Log    Navigated to checkout page

Fill Shipping Address Form
    # Fills all mandatory shipping address fields on the checkout page.
    # Default argument values use the Suite Variables from Generate Random User Data
    # so the form is populated with the same identity used during signup.
    # Hardcoded address defaults are sufficient for a demo store — no real
    # delivery validation occurs.
    [Arguments]
    ...    ${firstname}=${USER_FIRSTNAME}
    ...    ${email}=${REGISTERED_EMAIL}
    ...    ${street}=Jl. Sudirman No. 1
    ...    ${city}=Jakarta
    ...    ${state}=DKI Jakarta
    ...    ${zip_code}=10110
    ...    ${country}=Indonesia
    Wait Until Element Is Visible    ${CHECKOUT_SHIPPING_SECTION_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Set React Input Value    ${CHECKOUT_FIRSTNAME_INPUT}    ${firstname}
    Set React Input Value    ${CHECKOUT_EMAIL_INPUT}        ${email}
    Set React Input Value    ${CHECKOUT_STREET_INPUT}       ${street}
    Set React Input Value    ${CHECKOUT_CITY_INPUT}         ${city}
    Set React Input Value    ${CHECKOUT_STATE_INPUT}        ${state}
    Set React Input Value    ${CHECKOUT_ZIP_CODE_INPUT}     ${zip_code}
    Set React Input Value    ${CHECKOUT_COUNTRY_INPUT}      ${country}
    Log    Shipping address form filled

Save Shipping Address
    # Clicks "Save Address" to persist the shipping details before payment.
    # The checkout page requires this step before allowing order placement.
    # Sleep 1.5s gives the UI time to validate and acknowledge the saved address.
    Wait And Click Element    ${CHECKOUT_SAVE_ADDRESS_BTN}
    Sleep    1.5s
    Log    Shipping address saved

Select Cash On Delivery Payment
    # Selects Cash on Delivery (COD) as the payment method.
    # Why COD instead of Credit Card?
    #   COD requires no additional card detail fields, keeping the checkout
    #   flow simple and avoiding the need for test card numbers.
    Wait Until Element Is Visible    ${CHECKOUT_PAYMENT_SECTION_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Wait And Click Element    ${CHECKOUT_PAY_COD_BTN}
    Sleep    1s
    Log    Payment method selected: Cash on Delivery

Place Order
    # Scrolls the "Place Order" button into view before clicking to ensure
    # it is not obscured by a sticky header or is below the visible fold.
    # A screenshot is captured 2s after clicking to surface any validation
    # error messages that appear briefly and may cause a silent failure.
    Scroll Element Into View    ${CHECKOUT_PLACE_ORDER_BTN}
    Wait And Click Element    ${CHECKOUT_PLACE_ORDER_BTN}
    Log    Place Order button clicked — waiting for redirect
    Sleep    2s
    Capture Page Screenshot
    Log    Screenshot captured 2s after clicking Place Order

Verify Order Placed Successfully
    # Polls the browser URL every second for up to 30 seconds until the
    # page navigates away from /checkout. This replaces the fixed 3s sleep
    # because server processing time is non-deterministic; a hard-coded sleep
    # either times out too early or adds unnecessary delay on fast responses.
    # Why Wait Until Keyword Succeeds instead of Wait Until Location Contains?
    #   SeleniumLibrary provides "Location Should Contain" (positive) but not
    #   the negative equivalent. We use Wait Until Keyword Succeeds to poll
    #   a custom helper keyword that performs the negative assertion.
    ${left_checkout}=    Run Keyword And Return Status
    ...    Wait Until Keyword Succeeds    30s    1s    Checkout URL Should Have Changed
    IF    ${left_checkout}
        Log    Order placed successfully — left the checkout page
    ELSE
        Capture Screenshot On Failure
        Fail    Order failed — browser is still on the checkout page after 30 seconds
    END
    Log    Order confirmed for product: ${SELECTED_PRODUCT_NAME}

Checkout URL Should Have Changed
    # Helper keyword used by Wait Until Keyword Succeeds inside
    # Verify Order Placed Successfully. Fails (causing a retry) if the
    # current URL still contains "/checkout"; succeeds once the redirect fires.
    ${url}=    Get Location
    Should Not Contain    ${url}    /checkout
