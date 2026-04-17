"""
RandomHelper.py
---------------
Custom Robot Framework library for generating randomized test data.

Why a custom library?
    Robot Framework's built-in keywords do not natively support generating
    random emails with a specific domain (e.g., @yopmail.com). This library
    fills that gap using Python's standard modules, keeping the logic clean
    and reusable across all test suites.

Why @yopmail.com?
    Yopmail is a disposable email service that requires no registration.
    Emails sent to any @yopmail.com address can be viewed publicly at
    yopmail.com, making it ideal for end-to-end test verification without
    needing a real inbox.
"""

import random
import string
import time


class RandomHelper:
    """
    Provides keywords for generating random test data such as emails,
    names, and phone numbers.

    Registered as a Robot Framework keyword library via:
        Library    ${EXECDIR}/libraries/RandomHelper.py
    """

    # GLOBAL scope means one instance is shared across all test suites
    # in the same execution, avoiding redundant object creation.
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def generate_yopmail_email(self):
        """
        Generate a unique random email address using the @yopmail.com domain.

        Why this format?
            - 'testuser_' prefix makes it easy to identify test accounts in logs.
            - 8 random lowercase letters ensure uniqueness across parallel runs.
            - 4-digit timestamp suffix further reduces collision probability
              when tests run in quick succession.

        Returns:
            str: e.g., 'testuser_abcdefgh1234@yopmail.com'
        """
        prefix = "testuser_" + "".join(random.choices(string.ascii_lowercase, k=8))
        timestamp = str(int(time.time()))[-4:]
        email = f"{prefix}{timestamp}@yopmail.com"
        return email

    def generate_random_name(self):
        """
        Return a random first name from a predefined list.

        Why a fixed list instead of faker?
            Keeps the dependency minimal. The list contains common English
            names that are unlikely to trigger form validation issues.

        Returns:
            str: e.g., 'Alice'
        """
        names = ["Alice", "Bob", "Charlie", "Diana", "Edward", "Fiona", "George", "Hannah"]
        return random.choice(names)

    def generate_random_last_name(self):
        """
        Return a random last name from a predefined list.

        Returns:
            str: e.g., 'Johnson'
        """
        lastnames = ["Smith", "Johnson", "Brown", "Taylor", "Anderson", "Wilson", "Moore", "Davis"]
        return random.choice(lastnames)
