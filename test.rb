# :\Program Files (x86)\Windows Application Driver>WinAppDriver.exe 127.0.0.1 4723/wd/hub
require 'em/pure_ruby' # Must be before appium require.
require 'active_support/all'
require 'appium_lib'
require 'pry'
require 'rubygems'
require 'selenium-webdriver'

opts = {
  caps: {
    platformName: "WINDOWS",
    platform: "WINDOWS",
    deviceName: "WindowsPC",
    app: 'Microsoft.WindowsCalculator_8wekyb3d8bbwe!App'
  },
  appium_lib: {
    wait_timeout: 30,
    wait_interval: 0.5
  }
}

FA = { calculator_results: "CalculatorResults" }

FN = {
  zero: "Zero",
  one: "One",
  two: "Two",
  three: "Three",
  four: "Four",
  five: "Five",
  six: "Six",
  seven: "Seven",
  eight: "Eight",
  nine: "Nine",
  plus: "Plus",
  equals: "Equals",
  divide_by: "Divide by",
  multiply_by: "Multiply by",
  minus: "Minus",
  clear: "Clear"
}

class Calculator
  attr_accessor :app, :options

  FA.each { |k, v| define_method(k) { @app.find_element(accessibility_id: v) } }
  FN.each { |k, v| define_method(k) { @app.find_element(name: v) } }

  # c.exec('two', 'plus', 'two', "equals")
  # => "4"
  def exec(*args)
    clear.click
    args.each { |arg| send(arg).click }
    return calculatorresults.text.gsub('Display is ', '')
  end

  def initialize(options)
    @options = options
    @app = Appium::Driver.new(options, false).start_driver
  end

  # For any missing methods, try to delegate down to driver object.
  def method_missing(mth, *args, &block)
    if @app.respond_to? mth
      @app.send(mth, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @app.respond_to?(mth) || super
  end
end

calc = Calculator.new opts
binding.pry
calc.close
