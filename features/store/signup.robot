*** Settings ***
Documentation
...    Feature: User Signup
...
...    As a new visitor to TestDino Store
...    I want to register an account using a random yopmail.com email
...    So that I can access the shopping features of the platform
...
...    Precondition : None — this is the entry point of the user journey
...    Postcondition: A registered account exists; browser is on the login page

Library             SeleniumLibrary
Library             ${EXECDIR}/libraries/RandomHelper.py
Resource            ../../resources/variables.robot
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/keywords/auth_keywords.robot

# Suite Setup runs once before all test cases in this file.
# Opens the browser and lands on the homepage as a clean starting state.
Suite Setup         Open Browser To Homepage

# Suite Teardown closes all browser windows after the suite finishes,
# regardless of whether tests passed or failed.
Suite Teardown      Close All Open Browsers

# Test Teardown captures a screenshot when a test case fails,
# embedding it in the HTML log for immediate visual debugging.
Test Teardown       Run Keyword If Test Failed    Capture Screenshot On Failure


*** Test Cases ***
TC-01: Register A New Account With A Random YopMail Email
    [Documentation]
    ...    Scenario: A new user registers an account with a random @yopmail.com
    ...    email address and the default test password (Admin12345).
    ...
    ...    Given I am on the signup page
    ...    When I fill in the signup form with randomly generated credentials
    ...    And I submit the registration form
    ...    Then I am redirected to the login page confirming successful registration

    # Given — navigate to the signup page and confirm it is ready
    Given I Am On The Signup Page

    # When — generate random credentials, fill the form, and submit
    When I Fill The Signup Form With Random Credentials

    # Then — verify the site redirected to /login as expected after registration
    Then I Am Redirected To The Login Page


*** Keywords ***
I Am On The Signup Page
    # Opens /signup and asserts the page title element is present,
    # confirming the form has rendered before any input begins.
    Open Signup Page
    Page Should Contain Element    ${SIGNUP_PAGE_TITLE}

I Fill The Signup Form With Random Credentials
    # Generates a unique yopmail.com email and a random name, then fills
    # every required field using the default password (Admin12345).
    # Suite Variables are set here so TC-02 (login) can reuse the same
    # credentials without duplicating the signup step.
    Generate Random User Data
    Log    Registering with email: ${REGISTERED_EMAIL}
    Fill Signup Form
    ...    firstname=${USER_FIRSTNAME}
    ...    lastname=${USER_LASTNAME}
    ...    email=${REGISTERED_EMAIL}
    ...    password=${DEFAULT_PASSWORD}
    Submit Signup Form

I Am Redirected To The Login Page
    # Validates the expected post-signup behavior: the site does NOT auto-login.
    # Instead it redirects to /login, prompting the user to sign in manually.
    Verify Signup Redirected To Login Page
    Log    TC-01 PASSED — Account registered: ${REGISTERED_EMAIL}
