*** Variables ***
# auth_locators.robot
#
# Element locators for the Signup (/signup) and Login (/login) pages.
#
# Important: /register returns a 404. The correct signup URL is /signup.
# This was confirmed via DOM inspection of the live site.
#
# All locators use the "css:[data-testid='...']" strategy because the site
# exposes stable data-testid attributes on every interactive element.


# =============================================================================
# SIGNUP PAGE — /signup
# =============================================================================

# Input fields — each maps to a required registration form field
${SIGNUP_FIRSTNAME_INPUT}      css:[data-testid='signup-firstname-input']
${SIGNUP_LASTNAME_INPUT}       css:[data-testid='signup-lastname-input']
${SIGNUP_EMAIL_INPUT}          css:[data-testid='signup-email-input']
${SIGNUP_PASSWORD_INPUT}       css:[data-testid='signup-password-input']

# Submit button — labeled "Create Account" on the page
${SIGNUP_SUBMIT_BTN}           css:[data-testid='signup-submit-button']

# Navigation link — redirects to /login for users who already have an account
${SIGNUP_GO_TO_LOGIN_LINK}     css:[data-testid='signup-login-link']

# Page title — used to confirm the signup page has loaded ("Create Account")
${SIGNUP_PAGE_TITLE}           css:[data-testid='signup-title']


# =============================================================================
# LOGIN PAGE — /login
# =============================================================================

# Input fields — standard email/password login form
${LOGIN_EMAIL_INPUT}           css:[data-testid='login-email-input']
${LOGIN_PASSWORD_INPUT}        css:[data-testid='login-password-input']

# Submit button — labeled "Sign in" on the page
${LOGIN_SUBMIT_BTN}            css:[data-testid='login-submit-button']

# Navigation link — redirects to /signup for new users
${LOGIN_GO_TO_SIGNUP_LINK}     css:[data-testid='login-signup-link']

# Page title — used to confirm the login page has loaded ("Sign In")
${LOGIN_PAGE_TITLE}            css:[data-testid='login-title']
