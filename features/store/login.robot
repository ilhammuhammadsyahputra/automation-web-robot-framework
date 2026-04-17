*** Settings ***
Documentation
...    Feature: Login Akun Terdaftar
...
...    Sebagai pengguna yang sudah terdaftar
...    Saya ingin login dengan email dan password yang benar
...    Agar saya dapat mengakses fitur belanja

Library             SeleniumLibrary
Library             ${EXECDIR}/libraries/RandomHelper.py
Resource            ../../resources/variables.robot
Resource            ../../resources/keywords/common_keywords.robot
Resource            ../../resources/keywords/auth_keywords.robot

Suite Setup         Signup Terlebih Dahulu Dan Buka Browser
Suite Teardown      Close All Open Browsers
Test Teardown       Run Keyword If Test Failed    Capture Screenshot On Failure


*** Test Cases ***
TC-02: Login Dengan Akun Yang Sudah Terdaftar
    [Documentation]
    ...    Scenario: Login menggunakan email dan password dari akun yang sudah diregistrasi
    ...
    ...    Given saya sudah memiliki akun yang terdaftar
    ...    When saya membuka halaman login dan mengisi kredensial
    ...    And saya submit form login
    ...    Then saya berhasil masuk dan diarahkan ke homepage

    Given Saya Memiliki Akun Yang Sudah Terdaftar

    When Saya Login Dengan Kredensial Yang Benar

    Then Login Berhasil Dan Diarahkan Ke Homepage


*** Keywords ***
Signup Terlebih Dahulu Dan Buka Browser
    Open Browser To Homepage
    Do Signup With Random Email

Saya Memiliki Akun Yang Sudah Terdaftar
    Should Not Be Empty    ${REGISTERED_EMAIL}
    Log    Menggunakan akun: ${REGISTERED_EMAIL}

Saya Login Dengan Kredensial Yang Benar
    Open Login Page
    Fill Login Form    ${REGISTERED_EMAIL}    ${DEFAULT_PASSWORD}
    Submit Login Form

Login Berhasil Dan Diarahkan Ke Homepage
    Verify Login Redirected To Homepage
    Log    TC-02 PASSED: Login berhasil dengan akun ${REGISTERED_EMAIL}
