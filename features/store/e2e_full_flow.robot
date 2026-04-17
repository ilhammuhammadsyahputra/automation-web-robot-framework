*** Settings ***
Documentation
...    Feature: Full End-to-End Shopping Flow
...
...    As a brand new visitor to TestDino Store
...    I want to register, log in, browse products with a filter, and check out
...    So that the complete user journey can be validated in a single test run
...
...    This suite covers all steps in sequence within one browser session:
...      Step 1 — Generate random credentials and register a new account
...      Step 2 — Log in with the newly registered account
...      Step 3 — Navigate to the products page via the "Shop Now" button
...      Step 4 — Open the filter panel and select a product category
...      Step 5 — Add the first product in the filtered list to the cart
...      Step 6 — Complete checkout using Cash on Delivery
...      Step 7 — Verify the order was placed successfully
...
...    Precondition : None — the suite is fully self-contained
...    Postcondition: A new account exists and one order has been placed

Library             SeleniumLibrary
Library             ${EXECDIR}/libraries/RandomHelper.py
Resource            ../../resources/variables.robot
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/keywords/auth_keywords.robot
Resource            ../../resources/keywords/shop_keywords.robot

# Suite Setup only opens the browser. All actions are performed inside the
# single test case below so the full flow appears in one unbroken log trace.
Suite Setup         Open Browser To Homepage

Suite Teardown      Close All Open Browsers
Test Teardown       Run Keyword If Test Failed    Capture Screenshot On Failure


*** Test Cases ***
TC-E2E: New User Registers, Browses With Filter, And Completes Checkout
    [Documentation]
    ...    Scenario: A new user completes the full shopping journey from
    ...    account creation to order confirmation in one browser session.
    ...
    ...    Given I am a new visitor with no existing account
    ...    When I register with a random yopmail.com email and password Admin12345
    ...    And I log in with my newly created account
    ...    And I navigate to the products page via the Shop Now button
    ...    And I open the filter panel and apply a category filter
    ...    And I add the first filtered product to the cart
    ...    And I complete checkout using Cash on Delivery
    ...    Then my order is placed and confirmed

    # Step 1: Registration
    Given I Am A New Visitor With No Existing Account

    # Step 2 & 3: Account creation and authentication
    When I Register And Log In With A New Account

    # Step 4: Navigate to the store
    And I Navigate To Products Via Shop Now

    # Step 5 & 6: Browse with filter and add a product to the cart
    And I Filter Products And Add One To The Cart

    # Step 7: Complete the purchase
    And I Complete Checkout With Cash On Delivery

    # Final assertion
    Then My Order Is Placed And Confirmed


*** Keywords ***
I Am A New Visitor With No Existing Account
    # Generates a unique set of credentials and logs them for traceability.
    # This step exists as a Given clause to make the scenario readable —
    # no browser interaction is needed here since no account exists yet.
    Log    ── STEP 1: GENERATING CREDENTIALS ─────────────────
    Generate Random User Data
    Log    Email: ${REGISTERED_EMAIL} | Name: ${USER_FIRSTNAME} ${USER_LASTNAME}

I Register And Log In With A New Account
    # Runs signup and login back-to-back in the same keyword because the site
    # does not auto-login after registration — it redirects to /login instead.
    # Combining both steps here keeps the test case structure clean while
    # making the dependency explicit in the keyword name.
    Log    ── STEP 2-3: SIGNUP & LOGIN ──────────────────────
    # Signup
    Open Signup Page
    Fill Signup Form
    ...    firstname=${USER_FIRSTNAME}
    ...    lastname=${USER_LASTNAME}
    ...    email=${REGISTERED_EMAIL}
    ...    password=${DEFAULT_PASSWORD}
    Submit Signup Form
    Verify Signup Redirected To Login Page
    # Login — the signup page leaves us on /login, so we fill the form directly
    Fill Login Form    ${REGISTERED_EMAIL}    ${DEFAULT_PASSWORD}
    Submit Login Form
    Verify Login Redirected To Homepage
    Log    Authenticated as: ${REGISTERED_EMAIL}

I Navigate To Products Via Shop Now
    # Clicks the hero "Shop Now" button and confirms the /products page loads.
    # This tests the primary navigation path from the homepage to the catalog.
    Log    ── STEP 4: NAVIGATE TO PRODUCTS ───────────────────
    Click Shop Now On Homepage
    Verify Navigated To Products Page

I Filter Products And Add One To The Cart
    # Opens the filter sidebar, applies the "uncategorized" category filter,
    # logs the resulting product count, and adds the first product to the cart.
    # The filter step satisfies the requirement to demonstrate filter functionality
    # before adding a product.
    Log    ── STEP 5-6: FILTER & ADD TO CART ────────────────
    Open Filter Panel
    Select Category Filter    uncategorized
    ${count}=    Get Product Count From Results Label
    Log    Products after filter: ${count}
    Add First Product To Cart

I Complete Checkout With Cash On Delivery
    # Navigates to the cart, confirms the product is listed, proceeds to checkout,
    # fills the shipping address (using the registered user's details), saves it,
    # selects Cash on Delivery, and places the order.
    Log    ── STEP 7: CHECKOUT ─────────────────────────────
    Open Cart Page
    Verify Product Is In Cart
    Proceed To Checkout From Cart
    Fill Shipping Address Form
    Save Shipping Address
    Select Cash On Delivery Payment
    Place Order

My Order Is Placed And Confirmed
    # Asserts that the browser navigated away from /checkout, indicating the
    # order was accepted by the server and a confirmation page was shown.
    Log    ── STEP 8: VERIFY ORDER ──────────────────────────
    Verify Order Placed Successfully
    Log    TC-E2E PASSED | Email: ${REGISTERED_EMAIL} | Product: ${SELECTED_PRODUCT_NAME}
