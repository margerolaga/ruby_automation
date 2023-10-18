# Here we set the dependencies required to run the Ruby Program.
# We need the following gems to be required:
# Selenium-webdriver, logger and pony (email sending)
require 'selenium-webdriver'
require 'logger'
require 'pony'

# Here we create an options object indicating we use the headless version of chromedriver.
# A headless web browser is just a browser with no display.
# After days of debugging and troubleshooting, if a non-headless version of chromedriver is used,
# the cron job cannot run. It send an error that chrome cannot be opened.
options = Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
# Here we create a new WebDriver instance and use chromedriver with the options we just set
driver = Selenium::WebDriver.for :chrome, options: options

# We then set an implicit wait to apply to everytime we try to find an element on the webpage
# We give the program a maximum of 5 seconds to wait for a certain element to be displayed on screen before it can consider the element missing.
driver.manage.timeouts.implicit_wait = 10

# This initializes a new logger as the program begins.
# To make it simple, I researched and used some File commands here. The __FILE__ command comes from Ruby and gets the ruby scripts full path.
# From the Ruby file's full path, we extract the directory name using File.dirname().
# With File.join, we construct a path from the ruby directory to the logs directory and then finally to the selenium_log.html log.
# Finally, with File.expand_path(), we create an absolute path from the relative path created with File.join(), just to make sure an absolute path is created.
log_file_path = File.expand_path(File.join(File.dirname(__FILE__), 'logs', 'selenium_log.html'))
logger = Logger.new(log_file_path)
# Here, we changed the logger's overall format to have html tags and still display the severity, datetime and the error msg.
logger.formatter = proc do |severity, datetime, progname, msg|
    "<p><strong>#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}]:</strong> #{msg}</p>\n"
  end

# You can indicate other websites here to test websites that are down.
# Main website - https://rate-my-agent.com/
# Often Down Website - http://aol.sportingnews.com/
# Wrong Title Website - https://www.irctc.co.in/
# More down websites can be found in https://www.isitdownrightnow.com/
website_url = "https://rate-my-agent.com/"

# Below, we create a send_error_email method to call whenever we need to send an email.
# This is using the gmail smtp server for the pony gem.
# It takes 2 arguments, for the subject and body, so the email content can be changed depending on need.
# For testing, I created a gmail account rate.your.agent.automated@gmail.com to login to the gmail smtp server.
# You can change the to: field to "alerts@rate-my-agent.com".
def send_error_email(email_subject,email_body)

    Pony.mail({
        to: 'alerts@rate-my-agent.com',
        subject: email_subject,
        body: email_body,
        via: :smtp,
        via_options: {
          address: 'smtp.gmail.com',
          port: '587',
          user_name: 'rate.your.agent.automated@gmail.com',
          password: 'kwvp oaii dytm qsws',
          authentication: :plain,
          enable_starttls_auto: true
        }
      })
end


begin
    # This opens the website indicated in the website_url variable.
    driver.get website_url
    # To check if a website is up, there are several checks we can do. I will include all checks I can think of to see if a website is up.

    # First we can check if the page is showing the correct title.
    expected_title = "❤️Top Rated Real Estate Agents & Reviews of the Best Realtors in Canada & USA in 2022"
    page_title = driver.title

    # If the website title is incorrect, it shows up in the log file and an email is sent.
    if page_title != expected_title

        # This creates a timestamp object that extracts the exact time the error occured to be used for the email.
        timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")

        logger.warn("Website is up BUT something is wrong with the page title. Please check!")

        website_title_subject = "Selenium Test Result: Page Title Mismatch Detected"
        website_title_body = "This is an automated email. The result of a Selenium test indicates a page title mismatch.

        Details:
        - Expected Title: #{expected_title}
        - Actual Title: #{page_title}
        - Test Timestamp: #{timestamp}
        - Test URL: #{website_url}

        Action:
        - Check the website's title.

        Thank you."

        # A timestamp is included in the email content so that anyone checkign can immediately find the error on the logs.
        send_error_email(website_title_subject,website_title_body)
    end

    # The section below finds general elements of the website like the header, footer and main website content.
    # We do not really need to check each element, button or text in this test case. The main goal is just to check critical elements.

    # Below, we try to find the website's logo.
    website_logo = driver.find_element(xpath: "//nav[@class='mobile-scrolled-hidden navbar navbar-default navbar-fixed-top site-nav']//img[@alt='Rate My Agent']")

    # Below, we try to find the website's header using the id='siteMenu' locator
    homepage_navbar = driver.find_element(id: 'siteMenu')

    # Below, we try to find the div that contains the website's main content by using its class as a locator.
    homepage_body = driver.find_element(class: 'site-main')

    # Below, we try to find the div that contains the website's footer by using its class as a locator.
    homepage_footer = driver.find_element(class: 'site-footer')

    # Once all elements above are found and no other exceptions were encountered, the program logs into the log.txt file.
    logger.info("Website is up and running: #{website_url}")


# The section below contains all the handling of the exceptions that can be encountered during the test.

# The Selenium::WebDriver::Error::UnknownError happens when the website is down or is unresponsive.
# There may be times where initially the website opens when you do it manually, but when refreshed, an error occurs.
rescue Selenium::WebDriver::Error::UnknownError => e

    # This creates a timestamp object that extracts the exact time the error occured to be used for the email.
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    # This adds a Fatal error message within the logger to indicate the severity of the error.
    logger.fatal("Selenium::WebDriver::Error::UnknownError: WEBSITE IS DOWN: #{website_url}")
    # This logs the error message encountered into the log file.
    logger.fatal(e)

    # This sets the email subject and body to be sent to alerts@rate-my-agent.com.
    # I have included a timestamp in the email for ease of reference with the log file.
    website_down_subject = "Website Down Alert - #{website_url}"
    website_down_body = "This is an automated alert to inform you that #{website_url} is currently experiencing issues and is not accessible.

Details:
- Website URL: #{website_url}
- Timestamp: #{timestamp}
- Error Description: The website is not responding.

Action Required:
- Please investigate the issue and take appropriate steps to restore the website's functionality.
- You may need to contact your hosting provider or web administrator for assistance.

Thank you for your attention to this matter."

    send_error_email(website_down_subject,website_down_body)

# The Errno::ECONNREFUSED is usually covered by the Selenium::WebDriver::Error::UnknownError exception, but I just left this one here
# to ensure robustness. Further down the line, if this exception is never triggered, we can remove this rescue.
rescue Errno::ECONNREFUSED => e

    # This creates a timestamp object that extracts the exact time the error occured to be used for the email.
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    logger.fatal("Errno::ECONNREFUSED: WEBSITE IS DOWN: #{website_url}")
    logger.fatal(e)

    website_down_subject = "Website Down Alert - #{website_url}"
    website_down_body = "This is an automated alert to inform you that #{website_url} is currently experiencing issues and is not accessible.

Details:
- Website URL: #{website_url}
- Timestamp: #{timestamp}
- Error Description: The website is not responding.

Action Required:
- Please investigate the issue and take appropriate steps to restore the website's functionality.
- You may need to contact your hosting provider or web administrator for assistance.

Thank you for your attention to this matter."

    send_error_email(website_down_subject,website_down_body)

# The Selenium::WebDriver::Error::NoSuchElementError exception happens when selenium cannot find an element using the locators provided.
# Since each locator is verified to exist in the https://rate-my-agent.com/ webpage, then an element not found would mean that something is missing.
# This exception coveres all elements in the "begin" section so you might notice that the email is general.
# I have included the timestamp here so anyone can easily look for the error in the logs and investigate.
rescue Selenium::WebDriver::Error::NoSuchElementError => e

    # This creates a timestamp object that extracts the exact time the error occured to be used for the email.
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    logger.error("Missing Element found on homepage.")
    logger.error(e)

    missing_element_subject = "Selenium Test Error: Element is missing"
    missing_element_body = "This is an automated email. Please do not reply.

    A Selenium test encountered a No Such Element error during execution.

    Action:
    - Check the logs for errors in #{timestamp}.
    - Ensure page functionality.

    Thank you."

    send_error_email(missing_element_subject,missing_element_body)
end
