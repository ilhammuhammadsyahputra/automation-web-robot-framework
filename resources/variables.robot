*** Variables ***
# =============================================================================
# variables.robot
#
# Central configuration file for all test suites.
# Keeping variables here means changes to URLs, credentials, or browser
# settings only need to be made in one place.
# =============================================================================


# -----------------------------------------------------------------------------
# Application URLs
#
# Why define derived URLs from BASE_URL?
#   Robot Framework evaluates ${BASE_URL}/signup at runtime, so changing
#   BASE_URL automatically propagates to all derived URLs. This prevents
#   copy-paste errors when switching between environments (e.g., staging).
# -----------------------------------------------------------------------------
${BASE_URL}             https://storedemo.testdino.com
${SIGNUP_URL}           ${BASE_URL}/signup
${LOGIN_URL}            ${BASE_URL}/login
${PRODUCTS_URL}         ${BASE_URL}/products
${CART_URL}             ${BASE_URL}/cart
${CHECKOUT_URL}         ${BASE_URL}/checkout


# -----------------------------------------------------------------------------
# Browser & Timeout Configuration
#
# ${SELENIUM_TIMEOUT}  — Maximum seconds SeleniumLibrary waits for an element
#                        before raising ElementNotFound. Set to 15s to account
#                        for React's asynchronous rendering on slower networks.
#
# ${PAGE_LOAD_WAIT}    — Maximum seconds to wait for document.readyState to
#                        become "complete". Separate from element timeout
#                        because a page can be "complete" before React mounts
#                        all components.
# -----------------------------------------------------------------------------
${BROWSER}              chrome
${SELENIUM_TIMEOUT}     15
${PAGE_LOAD_WAIT}       30


# -----------------------------------------------------------------------------
# Test Credentials
#
# Why hardcode the password here instead of per test?
#   The site requires a specific password format (Admin12345). Centralizing it
#   avoids duplication and makes future changes straightforward.
# -----------------------------------------------------------------------------
${DEFAULT_PASSWORD}     Admin12345


# -----------------------------------------------------------------------------
# Shared Runtime Variables
#
# Why initialize as ${EMPTY}?
#   These variables are populated during test execution via Set Suite Variable.
#   Initializing them here prevents "Variable not found" errors if a keyword
#   references them before they are set (e.g., in a Suite Setup guard check).
# -----------------------------------------------------------------------------
${REGISTERED_EMAIL}     ${EMPTY}    # Populated by Generate Random User Data
${USER_FIRSTNAME}       ${EMPTY}    # Populated by Generate Random User Data
${USER_LASTNAME}        ${EMPTY}    # Populated by Generate Random User Data
