# Automation Web Robot — TestDino Store

Web automation project built with **Robot Framework** following a **BDD (Behavior-Driven Development)** approach, targeting [storedemo.testdino.com](https://storedemo.testdino.com).

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Project Structure](#2-project-structure)
3. [Installation](#3-installation)
4. [Configuration](#4-configuration)
5. [Running Tests](#5-running-tests)
6. [Test Scenarios](#6-test-scenarios)
7. [Viewing Reports](#7-viewing-reports)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Prerequisites

Ensure the following software is installed on your machine before proceeding:

| Software | Minimum Version | Check Command |
|---|---|---|
| Python | 3.8+ | `python3 --version` |
| pip | 21+ | `pip3 --version` |
| Google Chrome | Latest stable | Open Chrome → `chrome://version` |
| Git | Any | `git --version` |

> **ChromeDriver** is managed automatically. The `webdriver-manager` package downloads the correct ChromeDriver version based on your installed Chrome. No manual installation is needed.

---

## 2. Project Structure

```
automation-web-robot/
│
├── features/
│   └── store/
│       ├── signup.robot            # TC-01: New user registration
│       ├── login.robot             # TC-02: Sign in with a registered account
│       ├── shopping.robot          # TC-03 & TC-04: Store navigation, filter, and checkout
│       └── e2e_full_flow.robot     # TC-E2E: Full journey from signup to order confirmation
│
├── resources/
│   ├── keywords/
│   │   ├── common_keywords.robot   # Reusable browser interaction wrappers (click, input, wait)
│   │   ├── auth_keywords.robot     # Signup and login flow keywords
│   │   └── shop_keywords.robot     # Product browsing, cart, and checkout keywords
│   │
│   ├── locators/
│   │   ├── home_locators.robot     # Element locators for the homepage
│   │   ├── auth_locators.robot     # Element locators for signup and login pages
│   │   └── shop_locators.robot     # Element locators for products, cart, and checkout pages
│   │
│   └── variables.robot             # Global configuration: URLs, browser, credentials
│
├── libraries/
│   └── RandomHelper.py             # Custom Python library for generating random test data
│
├── reports/                        # Auto-generated on each run — do not edit manually
│   ├── log.html                    # Detailed step-by-step execution log with screenshots
│   ├── report.html                 # High-level pass/fail summary with statistics
│   └── output.xml                  # Machine-readable results for CI/CD integration
│
├── requirements.txt                # Python package dependencies
└── run_tests.sh                    # Shell script shortcuts for common run commands
```

---

## 3. Installation

### Step 1 — Clone or navigate to the project directory

```bash
cd /path/to/automation-web-robot
```

### Step 2 — Create a virtual environment (recommended)

A virtual environment isolates this project's dependencies from your global Python installation and prevents version conflicts.

```bash
# Create the virtual environment
python3 -m venv venv

# Activate it — macOS / Linux:
source venv/bin/activate

# Activate it — Windows (Command Prompt):
venv\Scripts\activate.bat

# Activate it — Windows (PowerShell):
venv\Scripts\Activate.ps1
```

Once activated, your terminal prompt will be prefixed with `(venv)`.

### Step 3 — Install dependencies

```bash
pip install -r requirements.txt
```

This installs the following packages:

| Package | Version | Purpose |
|---|---|---|
| `robotframework` | 7.1.1 | Core test automation framework |
| `robotframework-seleniumlibrary` | 6.3.0 | Browser control via Selenium WebDriver |
| `selenium` | 4.25.0 | WebDriver implementation |
| `webdriver-manager` | 4.0.2 | Automatically downloads the correct ChromeDriver |

### Step 4 — Verify the installation

```bash
robot --version
```

Expected output:
```
Robot Framework 7.1.1 (Python 3.x.x ...)
```

---

## 4. Configuration

All global settings are in `resources/variables.robot`. Edit this file to change the target URL, browser, or timeouts.

```robot
${BASE_URL}          https://storedemo.testdino.com   # Target application
${BROWSER}           chrome                            # Browser (chrome / firefox)
${SELENIUM_TIMEOUT}  15                               # Max wait time in seconds per element
${DEFAULT_PASSWORD}  Admin12345                       # Password for all generated test accounts
```

### Running in headless mode (no browser window)

Headless mode is required in CI/CD environments where no display is available. Update `Open Browser To Homepage` in `resources/keywords/common_keywords.robot`:

```robot
Open Browser To Homepage
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Create Webdriver    Chrome    options=${options}
    Go To    ${BASE_URL}
    Wait Until Page Is Loaded
```

### Switching to Firefox

```bash
pip install webdriver-manager
```

In `resources/variables.robot`:
```robot
${BROWSER}    firefox
```

---

## 5. Running Tests

### Option A — Shell script shortcuts

Make the script executable first (one-time setup):

```bash
chmod +x run_tests.sh
```

Then run by passing a suite name:

```bash
./run_tests.sh signup      # TC-01: Signup only
./run_tests.sh login       # TC-02: Login only
./run_tests.sh shopping    # TC-03 & TC-04: Navigation, filter, and checkout
./run_tests.sh e2e         # TC-E2E: Full end-to-end flow (recommended)
./run_tests.sh all         # All test suites sequentially
```

### Option B — Robot Framework CLI

```bash
# Run the full end-to-end test (recommended starting point)
robot --outputdir reports features/store/e2e_full_flow.robot

# Run a specific test suite
robot --outputdir reports features/store/shopping.robot

# Run all test suites
robot --outputdir reports features/store/

# Run a specific test case by name
robot --outputdir reports --test "TC-01*" features/store/signup.robot

# Run with verbose debug output
robot --outputdir reports --loglevel DEBUG features/store/e2e_full_flow.robot

# Override the browser at runtime without editing any file
robot --outputdir reports --variable BROWSER:firefox features/store/e2e_full_flow.robot
```

### What happens on each run

1. A fresh `@yopmail.com` account is generated with a random email address.
2. The account is registered and logged in automatically (Suite Setup).
3. Each test case runs sequentially in the browser.
4. Screenshots of any failures are embedded in the log.
5. Reports are written to the `reports/` directory.

---

## 6. Test Scenarios

### End-to-End Flow

```
[Signup with random email]
        │
        ▼
[Login with registered account]
        │
        ▼
[Homepage → Click "Shop Now" button]
        │
        ▼
[Products page → Open filter panel → Select "All" category]
        │
        ▼
[Find "Apple iPad Air (2022, 5th Gen)" → Add to cart]
        │
        ▼
[Go to /cart → Verify item → Click Checkout]
        │
        ▼
[Fill shipping address → Click "Save Address"]
        │
        ▼
[Select "Cash on Delivery" payment]
        │
        ▼
[Click "Place Order" → Order confirmed ✓]
```

### Test Case Details

| ID | File | Description | Pages Covered |
|---|---|---|---|
| TC-01 | `signup.robot` | Register a new account with a randomly generated `@yopmail.com` email | `/signup` |
| TC-02 | `login.robot` | Sign in using the account created in TC-01 | `/login` → `/` |
| TC-03 | `shopping.robot` | Click the "Shop Now" hero button and confirm the All Products page loads | `/` → `/products` |
| TC-04 | `shopping.robot` | Open filter panel, select category "All", add **Apple iPad Air (2022, 5th Gen)** to cart, and complete checkout via Cash on Delivery | `/products` → `/cart` → `/checkout` |
| TC-E2E | `e2e_full_flow.robot` | Full journey covering TC-01 through TC-04 in a single browser session | All pages |

### Test Data

| Field | Value |
|---|---|
| Email format | `testuser_[8 random chars][4-digit timestamp]@yopmail.com` |
| Password | `Admin12345` |
| Category filter | All |
| Target product | Apple iPad Air (2022, 5th Gen) |
| Payment method | Cash on Delivery (COD) |
| Shipping address | Jl. Sudirman No. 1, Jakarta, DKI Jakarta 10110, Indonesia |

### Locator Strategy

All element locators use `data-testid` CSS attributes (e.g., `css:[data-testid='signup-email-input']`). These are stable, semantic identifiers that are independent of element position, CSS classes, and layout changes. The `css:` prefix is required by SeleniumLibrary to interpret the selector correctly.

---

## 7. Viewing Reports

Reports are saved in the `reports/` directory after every test run.

```bash
# macOS
open reports/report.html

# Linux
xdg-open reports/report.html

# Windows
start reports\report.html
```

### Report files

| File | Contents |
|---|---|
| `report.html` | Overall pass/fail summary, test statistics, and execution duration |
| `log.html` | Step-by-step keyword trace, variable values, and embedded failure screenshots |
| `output.xml` | Raw XML results for CI/CD tools (Jenkins, GitHub Actions, etc.) |

> Failure screenshots are captured automatically and embedded in `log.html`. Each screenshot shows the exact browser state at the moment the test failed, making root cause analysis faster.

---