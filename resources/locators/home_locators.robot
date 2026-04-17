*** Variables ***
# home_locators.robot
#
# Element locators for the TestDino Store homepage.
#
# Why data-testid attributes?
#   The site was built with data-testid attributes specifically for test
#   automation. Unlike CSS classes (which change with styling updates) or
#   XPath (which breaks with structural changes), data-testid attributes
#   are stable as long as the element's purpose remains the same.
#
# Why "css:" prefix?
#   SeleniumLibrary requires an explicit "css:" prefix for CSS selectors.
#   Without it, the string is treated as an element ID lookup, which fails
#   for attribute selectors like [data-testid='...'].


# Hero Section
# The primary call-to-action button in the homepage hero banner.
# Clicking it navigates the user to the /products page.
${HOME_HERO_SHOP_NOW_BTN}      css:[data-testid='hero-shop-now']

# Header Navigation
# The "All Products" menu item in the top navigation bar.
# Contains a link that routes to /products — used as an alternative
# to the hero button when the page is scrolled or the hero is not visible.
${HEADER_NAV_ALL_PRODUCTS}     css:[data-testid='header-menu-all-products']

# Cart and user icons in the header, used to confirm a logged-in state
# or to open the cart drawer.
${HEADER_CART_ICON}            css:[data-testid='header-cart-icon']
${HEADER_USER_ICON}            css:[data-testid='header-user-icon']
