#!/bin/bash
# run_tests.sh — Shortcut script for running Robot Framework test suites.
# Usage: ./run_tests.sh [signup|login|shopping|e2e|all]

case "$1" in
  "signup")
    echo "Running Signup tests (TC-01)..."
    robot --outputdir reports features/store/signup.robot
    ;;
  "login")
    echo "Running Login tests (TC-02)..."
    robot --outputdir reports features/store/login.robot
    ;;
  "shopping")
    echo "Running Shopping tests (TC-03, TC-04)..."
    robot --outputdir reports features/store/shopping.robot
    ;;
  "e2e")
    echo "Running Full End-to-End test (TC-E2E)..."
    robot --outputdir reports features/store/e2e_full_flow.robot
    ;;
  "all")
    echo "Running all test suites..."
    robot --outputdir reports features/store/
    ;;
  *)
    echo "Usage: ./run_tests.sh [signup|login|shopping|e2e|all]"
    echo ""
    echo "  signup    TC-01 — User registration"
    echo "  login     TC-02 — Sign in with registered account"
    echo "  shopping  TC-03 & TC-04 — Product navigation, filter, and checkout"
    echo "  e2e       TC-E2E — Full end-to-end flow (recommended)"
    echo "  all       All suites sequentially"
    exit 1
    ;;
esac

echo ""
echo "Reports saved to: reports/report.html"
