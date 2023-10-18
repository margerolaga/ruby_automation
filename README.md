# ruby_automation Mar Gerolaga - QA Developer application

## Objective
The goal is to create a simple automated script that periodically checks the availability of Rate-My-Agent.com and reports any downtime immediately.

## Installation
Note: A Linux system is considered when making the instructions below.
To install all dependencies for the Selenium Ruby program, please follow the following steps:

Pre-requisites:
Ruby v3.2.2 or higher
Latest Google Chrome Version (v118)
Machine must be connected to the internet

You can try running the installer.sh file in the root folder to install all necessary dependencies.
Please run the installer.sh file in the directory where you want to clone the repo.

If the installer.sh file does not work, please follow the instructions below.

Please update your package repositories before proceeding.
sudo apt update

1. Install the latest version of chromedriver
    1. Navigate to https://googlechromelabs.github.io/chrome-for-testing/#stable and download the chromedriver for v118
    2. Unzip the downloaded file
        unzip chromedriver_linux64.zip 

    3. Move the chromedriver file to /usr/bin/chromedriver. Execute the following commands:
        sudo mv chromedriver /usr/bin/chromedriver
        sudo chown root:root /usr/bin/chromedriver 
        sudo chmod +x /usr/bin/chromedriver

    4. Run the command to test if chromedriver started successfully.
        chromedriver --url-base=/wd/hub

2. Clone the repository to a directory of your choice
git clone https://github.com/margerolaga/ruby_automation.git

3. Navigate to the directory the repo was cloned
cd ruby_automation

4. Check the files in the repo:<br />
|---/config<br />
|   |---schedule.rb<br />
|---/logs<br />
|   |---selenium_log.html<br />
|---Gemfile<br />
|---Gemfile.lock<br />
|---rma_website_checker.rb<br />
|---README.md<br />

5. Install bundler in the machine<br />
gem install bundler

6. Install all the required gems referred to in the Gemfile<br />
bundle install

7. Install the "Whenever" gem. This is because the installation using the bundle install command is not enough to install the methods needed to run this gem.<br />
gem install whenever

8. Try and run the selenium program once to ensure everything is working.<br />
ruby website_checker_headless.rb

This command will not open a chrome tab. To know if the program was successful, check the /logs/selenium_log.html file.
Use the command below to open it on chrome<br />
google-chrome logs/selenium_log.html<br /><br />

It should have the logs for when the program was ran and it should say the website is up. 
If you encounter errors, please don't hesitate to contact Mar.

9. Create the cron job to automate running the ruby program. Here we will use the "Whenever" gem for Ruby. Perform the command:<br />
whenever --update-crontab

10. Check the crontab for the created cron job<br />
crontab -l<br /><br />

It should show that the cron job will run every 3rd minute within the hour and should lead to the website_checker_headless.rb file.

11. Wait for the Ruby program to run.

12. In 3 minutes, you should be able to check the /logs/selenium_log.html file for the latest run of the program.

13. To test a down website, open the website_checker_headless.rb in a text editor. <br />
Edit the website_url object. Some sample websites that are down must be indicated in the comments above the object.
You can find this variable in line 37 of website_checker_headless.rb.

14. In line 47 of website_checker_headless.rb, 