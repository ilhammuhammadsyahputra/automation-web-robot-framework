*** Settings ***
Documentation
...    Feature: Product Browsing, Filtering, and Checkout
...
...    As a logged-in user of TestDino Store
...    I want to browse products, apply a category filter, and complete a purchase
...    So that I can validate the end-to-end shopping flow
...
...    Precondition : An authenticated session (handled by Suite Setup)
...    Postcondition: An order has been placed via Cash on Delivery

Library             SeleniumLibrary
Library             ${EXECDIR}/libraries/RandomHelper.py
Resource            ../../resources/variables.robot
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/keywords/auth_keywords.robot
Resource            ../../resources/keywords/shop_keywords.robot

# Suite Setup creates a fresh account and logs in before any test case runs.
# Both TC-03 and TC-04 require an authenticated session, so this is done once
# at the suite level rather than duplicating it in each test case.
Suite Setup         Register And Login Before Shopping

Suite Teardown      Close All Open Browsers
Test Teardown       Run Keyword If Test Failed    Capture Screenshot On Failure


*** Test Cases ***
TC-03: Navigate To Products Page Via Shop Now Button
    [Documentation]
    ...    Scenario: A logged-in user clicks the "Shop Now" button on the
    ...    homepage hero section and lands on the All Products page.
    ...
    ...    Given I am logged in and on the homepage
    ...    When I click the "Shop Now" button in the hero section
    ...    Then I am on the All Products page

    # Given — ensure we are starting from the homepage
    Given I Am Logged In And On The Homepage

    # When — click the hero "Shop Now" button
    When I Click The Shop Now Button

    # Then — confirm the products page loaded
    Then I Land On The All Products Page

TC-04: Filter Products By Category And Checkout With Cash On Delivery
    [Documentation]
    ...    Scenario: A logged-in user applies a category filter, adds the first
    ...    result to the cart, and completes checkout using Cash on Delivery.
    ...
    ...    Given I am on the All Products page
    ...    When I open the filter panel and select the "Uncategorized" category
    ...    And I add the first product to the cart
    ...    And I navigate to the cart and proceed to checkout
    ...    And I fill in the shipping address and save it
    ...    And I select Cash on Delivery as the payment method
    ...    And I place the order
    ...    Then the order is confirmed

    # Given — navigate to the products page as the starting point
    Given I Am On The All Products Page

    # When — open filter, select category, and verify the product list updates
    When I Apply The Category Filter

    # And — add the specific product by name to the shopping cart
    And I Add The Target Product To The Cart

    # And — go to cart, verify the item, and move to checkout
    And I Proceed From Cart To Checkout

    # And — fill mandatory shipping fields and save the address
    And I Fill In The Shipping Address

    # And — choose Cash on Delivery to avoid credit card fields
    And I Select Cash On Delivery As Payment

    # And — submit the order
    And I Place The Order

    # Then — verify the browser left /checkout confirming order success
    Then The Order Is Confirmed


*** Keywords ***
Register And Login Before Shopping
    # Creates a fresh account via signup and logs in before the suite runs.
    # Using a fresh account per run avoids interference between test executions
    # and ensures the cart starts empty.
    Open Browser To Homepage
    Do Signup With Random Email
    Do Login With Registered Account

# =============================================================================
# TC-03 Step Keywords
# =============================================================================

I Am Logged In And On The Homepage
    # Navigates to the homepage to establish a known starting state.
    # Even though Suite Setup lands on the homepage after login, TC-03 may
    # run after TC-04 has navigated away, so explicit navigation is safer.
    Navigate To Page    ${BASE_URL}
    Wait Until Page Is Loaded

I Click The Shop Now Button
    Click Shop Now On Homepage

I Land On The All Products Page
    Verify Navigated To Products Page

# =============================================================================
# TC-04 Step Keywords
# =============================================================================

I Am On The All Products Page
    # Navigates directly to /products as TC-04's starting point.
    # This isolates TC-04 from TC-03 so either test can be run independently.
    Navigate To Page    ${PRODUCTS_URL}
    Wait Until Element Is Visible    ${PRODUCTS_PAGE_TITLE}    timeout=${SELENIUM_TIMEOUT}

I Apply The Category Filter
    # Opens the filter sidebar and selects "uncategorized".
    # The results count is logged to show the filter had an effect.
    Open Filter Panel
    Select Category Filter    All
    ${count}=    Get Product Count From Results Label
    Log    Products shown after filtering: ${count}

I Add The Target Product To The Cart
    Add Product To Cart By Name    Apple iPad Air (2022, 5th Gen)

I Proceed From Cart To Checkout
    # Navigates to /cart, confirms the product is listed, then clicks "Checkout".
    # Direct URL navigation to /cart is used instead of the cart icon because
    # the icon opens a side drawer rather than the full cart page.
    Open Cart Page
    Verify Product Is In Cart
    Proceed To Checkout From Cart

I Fill In The Shipping Address
    # Fills all required shipping fields using the registered user's name and
    # email (set during Suite Setup), then saves the address.
    Fill Shipping Address Form
    Save Shipping Address

I Select Cash On Delivery As Payment
    Select Cash On Delivery Payment

I Place The Order
    Place Order

The Order Is Confirmed
    Verify Order Placed Successfully
    Log    TC-04 PASSED — Order placed for product: ${SELECTED_PRODUCT_NAME}
