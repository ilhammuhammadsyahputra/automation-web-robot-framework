*** Settings ***
# auth_keywords.robot
#
# Keywords for the signup and login flows of TestDino Store.
# Each keyword maps to a single, meaningful action so that test cases
# read like plain English and remain easy to maintain.
#
# Why separate auth keywords from common keywords?
#   Auth logic (form filling, redirects, credential management) is specific
#   to authentication pages. Keeping it isolated means changes to the
#   signup/login UI only require updates in this one file.

Library     SeleniumLibrary
Library     ${EXECDIR}/libraries/RandomHelper.py
Resource    ../variables.robot
Resource    ../locators/auth_locators.robot
Resource    common_keywords.robot


*** Keywords ***
Generate Random User Data
    # Generates a unique set of user credentials and stores them as Suite Variables
    # so they are accessible by all subsequent keywords and test cases in the suite.
    #
    # Why Suite Variable instead of a return value?
    #   Multiple keywords (signup, login, checkout) need the same email and name.
    #   Suite Variables act as a shared state within one test run, avoiding the
    #   need to pass these values through every keyword argument chain.
    ${email}=           Generate Yopmail Email
    ${firstname}=       Generate Random Name
    ${lastname}=        Generate Random Last Name
    Set Suite Variable  ${REGISTERED_EMAIL}     ${email}
    Set Suite Variable  ${USER_FIRSTNAME}       ${firstname}
    Set Suite Variable  ${USER_LASTNAME}        ${lastname}
    Log    Generated credentials — Email: ${email} | Name: ${firstname} ${lastname}
    RETURN    ${email}

Open Signup Page
    # Navigates to the signup page and confirms the email field is present
    # before proceeding. This acts as an implicit assertion that the page
    # rendered correctly rather than showing a 404 or redirect.
    Navigate To Page    ${SIGNUP_URL}
    Wait Until Element Is Visible    ${SIGNUP_EMAIL_INPUT}    timeout=${SELENIUM_TIMEOUT}

Fill Signup Form
    # Fills all required fields of the signup form in the order they appear
    # on the page (top to bottom) to mimic natural user behavior.
    [Arguments]    ${firstname}    ${lastname}    ${email}    ${password}
    Wait And Input Text    ${SIGNUP_FIRSTNAME_INPUT}    ${firstname}
    Wait And Input Text    ${SIGNUP_LASTNAME_INPUT}     ${lastname}
    Wait And Input Text    ${SIGNUP_EMAIL_INPUT}        ${email}
    Wait And Input Text    ${SIGNUP_PASSWORD_INPUT}     ${password}

Submit Signup Form
    # Clicks the "Create Account" button and waits 2 seconds for the server
    # to process the registration request and trigger the redirect.
    # Why Sleep instead of Wait Until Location Contains?
    #   The redirect may go through an intermediate loading state. A short
    #   sleep prevents the next assertion from running before the redirect
    #   animation completes.
    Wait And Click Element    ${SIGNUP_SUBMIT_BTN}
    Sleep    2s

Verify Signup Redirected To Login Page
    # After successful signup, the site redirects to /login (not auto-login).
    # This keyword confirms that behavior so the test fails fast if the
    # redirect stops working due to a site change.
    Wait Until Location Contains    /login    timeout=${SELENIUM_TIMEOUT}
    Wait Until Element Is Visible   ${LOGIN_PAGE_TITLE}    timeout=${SELENIUM_TIMEOUT}
    Log    Signup successful — redirected to login page

Open Login Page
    # Navigates to the login page and waits for the email field to confirm
    # the page is ready for interaction.
    Navigate To Page    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOGIN_EMAIL_INPUT}    timeout=${SELENIUM_TIMEOUT}

Fill Login Form
    # Fills the email and password fields. Arguments allow reuse with
    # different credentials (e.g., wrong password in negative test cases).
    [Arguments]    ${email}    ${password}
    Wait And Input Text    ${LOGIN_EMAIL_INPUT}      ${email}
    Wait And Input Text    ${LOGIN_PASSWORD_INPUT}   ${password}

Submit Login Form
    # Clicks "Sign in" and waits 2 seconds for the authentication response
    # and homepage redirect to complete before the next assertion runs.
    Wait And Click Element    ${LOGIN_SUBMIT_BTN}
    Sleep    2s

Verify Login Redirected To Homepage
    # Confirms a successful login by checking that the URL no longer contains /login.
    # The site redirects authenticated users to the homepage (/) on success.
    # Why Get Location + Should Not Contain instead of "Location Should Not Contain"?
    #   SeleniumLibrary only provides Location Should Contain (positive assertion).
    #   For the negative case, we fetch the URL with Get Location and use the
    #   Robot Framework BuiltIn keyword Should Not Contain.
    Wait Until Location Contains    ${BASE_URL}/    timeout=${SELENIUM_TIMEOUT}
    ${current_url}=    Get Location
    Should Not Contain    ${current_url}    /login
    Log    Login successful — redirected to homepage

Do Signup With Random Email
    # Convenience keyword that runs the full signup flow in a single call.
    # Used in Suite Setup of test files that require an existing account
    # (e.g., login.robot, shopping.robot) to set up the precondition.
    Generate Random User Data
    Open Signup Page
    Fill Signup Form
    ...    firstname=${USER_FIRSTNAME}
    ...    lastname=${USER_LASTNAME}
    ...    email=${REGISTERED_EMAIL}
    ...    password=${DEFAULT_PASSWORD}
    Submit Signup Form
    Verify Signup Redirected To Login Page

Do Login With Registered Account
    # Convenience keyword that runs the full login flow in a single call.
    # Default arguments use the Suite Variables set by Generate Random User Data,
    # so no explicit arguments are needed when called after Do Signup With Random Email.
    [Arguments]    ${email}=${REGISTERED_EMAIL}    ${password}=${DEFAULT_PASSWORD}
    Open Login Page
    Fill Login Form    ${email}    ${password}
    Submit Login Form
    Verify Login Redirected To Homepage
