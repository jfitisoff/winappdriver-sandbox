# pip3 install appium-python-client
import atexit
from appium import webdriver
import ipdb
import re

desired_caps = {}
desired_caps["app"] = "Microsoft.WindowsCalculator_8wekyb3d8bbwe!App"
driver = webdriver.Remote(command_executor='http://127.0.0.1:4723/wd/hub',
    desired_capabilities= desired_caps)

FA = {
    "calculator_results": "CalculatorResults"
}

FN = {
    "zero": "Zero",
    "one": "One",
    "two": "Two",
    "three": "Three",
    "four": "Four",
    "five": "Five",
    "six": "Six",
    "seven": "Seven",
    "eight": "Eight",
    "nine": "Nine",
    "plus": "Plus",
    "equals": "Equals",
    "divide_by": "Divide by",
    "multiply_by": "Multiply by",
    "minus": "Minus",
    "clear": "Clear"
}

class Calculator(object):
    def __getattr__(self, name):
        if name in FN.keys():
            return driver.find_element_by_name(FN[name])
        elif name in FA.keys():
            return driver.find_element_by_accessibility_id(FA[name])
        elif name in dir(self.app):
            return getattr(self.app, name)
        else:
            super()

    # calc.exec('two', 'plus', 'two', "equals")
    # "4"
    def exec(self, *args):
        calc.clear.click()

        for arg in args:
            getattr(self, arg).click()

        return re.sub('Display is ', '',
            getattr(self, 'calculator_results').text)

    def __init__(self, driver):
        self.app = driver

calc = Calculator(driver)
atexit.register(calc.close)
ipdb.set_trace()
