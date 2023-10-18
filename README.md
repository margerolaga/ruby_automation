# ruby_automation Mar Gerolaga - QA Developer application

## Objective
The goal is to create a simple automated script that periodically checks the availability of Rate-My-Agent.com and reports any downtime immediately. This project will help ensure the website never goes down and demonstrates your skills in software QA, automation, and basic Ruby scripting.

## Instructions
1. Write a Ruby script that uses the Selenium web automation framework to periodically visit Rate-My-Agent.com.
2. Implement a test function to check if the website is up and running correctly. You get to decide what the function tests for.
3. Provide a README.md file with instructions on how to set up and run the script.
4. Write a cron job line, as part of the installation instructions, to schedule the script to run every 3 minutes.
5. If the script encounters any issues with the website, such as a 404 error or content mismatch, it must send an email notification to alerts@rate-my-agent.com. You get to decide what the email notification says, what subject it has, etc.
6. The script should also log the status of each check in a text file, including timestamps.
7. Feel free to include explanations of the code and design choices you've made as comments in the script

Bonus Tasks:
1. Instead of a text file, make it an html file
2. Create a bash script to automate the deployment and scheduling of the Ruby script.

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
    1.1 Navigate to https://googlechromelabs.github.io/chrome-for-testing/#stable and download the chromedriver for v118
    1.2 Unzip the downloaded file
        unzip chromedriver_linux64.zip 

    1.3 Move the chromedriver file to /usr/bin/chromedriver. Execute the following commands:
        sudo mv chromedriver /usr/bin/chromedriver
        sudo chown root:root /usr/bin/chromedriver 
        sudo chmod +x /usr/bin/chromedriver

    1.4 Run the command to test if chromedriver started successfully.
        chromedriver --url-base=/wd/hub

2. Clone the repository to a directory of your choice
git clone https://github.com/margerolaga/ruby_automation.git

3. Navigate to the directory the repo was cloned
cd ruby_automation

4. Check the files in the repo:
|---/config
|   |---schedule.rb
|---/logs
|   |---selenium_log.html
|---Gemfile
|---Gemfile.lock
|---website_checker_headless.rb
|---README.md

5. Install bundler in the machine
gem install bundler

6. Install all the required gems referred to in the Gemfile
bundle install

7. Install the "Whenever" gem. This is because the installation using the bundle install command is not enough to install the methods needed to run this gem.
gem install whenever

8. Try and run the selenium program once to ensure everything is working.
ruby website_checker_headless.rb

This command will not open a chrome tab. To know if the program was successful, check the /logs/selenium_log.html file.
Use the command below to open it on chrome
google-chrome logs/selenium_log.html

It should have the logs for when the program was ran and it should say the website is up. 
If you encounter errors, please don't hesitate to contact Mar.

9. Create the cron job to automate running the ruby program. Here we will use the "Whenever" gem for Ruby. Perform the commands:
whenever --update-crontab

10. Check the crontab for the created cron job
crontab -l

It should show that the cron job will run every 3rd minute within the hour and should lead to the website_checker_headless.rb file.

11. Wait for the Ruby program to run.

12. In 3 minutes, you should be able to check the /logs/selenium_log.html file for the latest run of the program.

13. To test a down website, open the website_checker_headless.rb in a text editor. 
Edit the website_url object. Some sample websites that are down must be indicated in the comments above the object.
You can find this variable in line 37 of website_checker_headless.rb.