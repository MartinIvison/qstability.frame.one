This is a **shell automated test suite** to test against web apps. It is written in Ruby and architected around SitePrism (built on Capybara) and uses Selenium to talk to a variety of web-drivers (Browserstack, Chromedriver etc.).


## 1. Manual Installation
1. Clone or download repo.
2. Run `bundle install`
3. Run `bundle update`
At this point you will be able to run the tests in Browserstack, but not in local browsers. For these install drivers as needed:
- Phantomjs headless browser: `brew install phantomjs`
- Firefox: `brew install geckodriver`
- Chrome: `brew install chromedriver` (to update: `brew upgrade chromedriver`)

## 2. Create Secrets
Write the missing secrets file:
  - Create the secrets file: `echo >> 'settings/accounts.yaml'`
  - Install a text editor: `apt-get update && \ apt-get -y install nano`
  - Open the new accounts file in the text editor: `nano settings/accounts.yaml`
  - Copy the following content into the file, save and exit:

  ```#unit-test
  unit-test:
    value: true

  #browserstack credentials
  Browserstack:
    key:
    user:
    ```

## 3. Run tests
1. Type `rake test` or `ruby test.rb` (with default suite and default settings)
2. To specify which test suite to run, modify or create a test suite in `suites`. Then run `ruby test.rb "suite-name"`.
3. To set specific run settings, like environment and browser-mode, modify or add a named settings block in `settings/settings.yaml` (e.g. 'jenkins')
4. To run with specific settings, set add the settings argument, as follows: `test.rb "suite-name" "settings-name" "bs mode" "bs number(s)"`. Examples:
- ruby test.rb  - without arguments, runs default suite with default settings (settings.yaml)
- ruby test.rb "default"  - runs default suite with default settings
- ruby test.rb "default" "default"  - runs default suite with default settings
- ruby test.rb "default" "browserstack"  - browserstack without arguments runs on the first browser in the list (browsers.yaml)
- ruby test.rb "default" "browserstack" "all"  - runs on all browserstack
- ruby test.rb "default" "browserstack" "one" "2"  - runs on browser 2 in the list
- ruby test.rb "default" "browserstack" "select" "2 3 4"  - runs on browsers 2,3,4
- ruby test.rb "default" "browserstack" "random" "1 2 6"  - runs on a random browsers from the list specified in the argument

## 4. Run Unit Tests
1. Run `ruby unit_test.rb`

## Design and Abilities
- Structure: basic framework built on capybara, siteprism, selenium webdriver
- Structure: modular test taxonomy (suites, scenarios, steps), and separate object management and object taxonomy (site, page, section, element)
- Structure: common helper functions for setup and tear-down, data generation, error handling, reporting, verification, object treatment etc
- Structure: ability to vary environments, accounts and run-time settings from settings, environments and accounts yaml files.
- Reporting: basic result reporting in console, and ability to run in debug mode
- Error Handling: retry, handling of hard errors and saving screenshots on failure
- Integration: ability to vary browsers and test headless (poltergeist/phantomjs)
- Integration: ability to run on **Browserstack** (single and multiple browsers in sequence) via "browserstack" commandline argument
- Integration: ability to run test from **Jenkins** build (on build server, or on Browserstack) via Rake task, and ability to stability-test on Jenkins.
- Containerization in **Docker**, and ability to be run from **CircleCI** against Browserstack.
