*** Settings ***
# common_keywords.robot
#
# Low-level, reusable browser interaction keywords shared across all test suites.
# These wrap SeleniumLibrary's built-in keywords to enforce consistent
# wait-before-act behavior throughout the project.
#
# Why wrap SeleniumLibrary keywords instead of calling them directly?
#   Direct calls like "Click Element" do not wait for the element to be visible,
#   which causes flaky tests on dynamic React pages. Centralizing the
#   wait-then-act pattern here ensures every interaction is safe by default.

Library     SeleniumLibrary
Library     OperatingSystem
Resource    ../variables.robot


*** Keywords ***
Open Browser To Homepage
    # Opens a maximized browser window and navigates to the application homepage.
    # Maximize is applied so that all elements are visible and not hidden
    # behind a mobile/hamburger layout, which could cause locator failures.
    # Implicit wait is set globally so every subsequent element lookup
    # benefits from a built-in polling interval without additional keywords.
    Open Browser                    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait      ${SELENIUM_TIMEOUT}
    Set Selenium Page Load Timeout  ${PAGE_LOAD_WAIT}
    Wait Until Page Is Loaded

Navigate To Page
    # Navigates directly to the given URL and waits for the page to finish
    # loading. Used instead of clicking links when a direct URL jump is
    # more reliable (e.g., navigating to /cart after adding a product).
    [Arguments]    ${url}
    Go To    ${url}
    Wait Until Page Is Loaded

Wait Until Page Is Loaded
    # Polls document.readyState until it returns "complete".
    # Why not just use Sleep?
    #   Sleep is a fixed delay that either waits too long or not long enough.
    #   Polling readyState exits as soon as the browser signals the page is
    #   ready, making tests faster and more reliable.
    Wait For Condition    return document.readyState == "complete"    timeout=30

Wait And Click Element
    # Waits for the element to become visible, then clicks it.
    # Why wait before clicking?
    #   React components render asynchronously. Clicking before the element
    #   is mounted results in an ElementNotFound or ElementNotInteractable
    #   error. This pattern eliminates that race condition.
    [Arguments]    ${locator}    ${timeout}=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Click Element    ${locator}

Wait And Input Text
    # Waits for the element to be visible, clears any pre-existing value,
    # then types the new text.
    # Why clear before input?
    #   Some form fields are pre-filled (e.g., email from a previous session).
    #   Clearing first ensures the final value is exactly what the test provides.
    [Arguments]    ${locator}    ${text}    ${timeout}=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Set React Input Value
    # Sets the value of a React controlled input field using JavaScript.
    # Why not use Input Text (send_keys)?
    #   React controlled inputs store their value in React's virtual DOM state,
    #   not just the raw DOM value. Selenium's element.clear() + send_keys()
    #   triggers native DOM events but can fail to update React's internal state
    #   in some component implementations, causing validation to see an empty value.
    #   Using the native HTMLInputElement value setter + dispatching an 'input'
    #   event is the standard pattern that reliably triggers React's onChange.
    [Arguments]    ${locator}    ${value}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    ...    setter.call(arguments[0], arguments[1]);
    ...    arguments[0].dispatchEvent(new Event('input', {bubbles: true}));
    ...    arguments[0].dispatchEvent(new Event('change', {bubbles: true}));
    ...    ARGUMENTS    ${element}    ${value}

Wait And Select By Value
    # Waits for a <select> dropdown to be visible, then selects the option
    # matching the given value attribute. Using value (not visible text)
    # makes selection locale-independent and more stable across UI updates.
    [Arguments]    ${locator}    ${value}    ${timeout}=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Select From List By Value    ${locator}    ${value}

Capture Screenshot On Failure
    # Takes a full-page screenshot and embeds it in the Robot Framework log.
    # Called automatically via Test Teardown when a test case fails,
    # providing visual context for debugging without manual reproduction.
    Capture Page Screenshot

Close All Open Browsers
    # Closes every browser window opened during the test session.
    # Called in Suite Teardown to guarantee cleanup even when tests fail.
    Close All Browsers
