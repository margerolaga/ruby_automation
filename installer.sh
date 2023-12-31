#!/bin/bash

# Update package repositories
echo "sudo apt update will be ran to update the package information of your machine. Please enter your password when prompted. Thanks!"
sudo apt update

# Step 1: Install chromedriver for Chrome version 118
echo "Installing chromedriver for chrome v118..."
wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/118.0.5993.70/linux64/chromedriver-linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/local/bin/
chmod +x /usr/local/bin/chromedriver

# Step 2: Clone the repository
echo "Cloning git repository..."
git clone https://github.com/margerolaga/ruby_automation.git

# Step 3: Navigate to the root folder
echo "Navigating to the repo's root folder..."
cd ruby_automation

# Step 4: Install bundler in the machine
echo "Installing the bundler gem..."
gem install bundler

# Step 5: Install gems from the Gemfile
echo "Installing all gem dependencies..."
bundle install

# Step 6: Install the whenever gem
echo "Installing the whatever gem..."
gem install whenever

# Step 7: Run the Ruby program to check if it works
echo "Running selenium script..."
ruby rma_website_checker.rb

# Step 8: Open the log file to check if the program ran successfully
echo "Opening html log file..."
google-chrome logs/selenium_log.html

echo "Making sure selenium script is executable for cron..."
chmod +x rma_website_checker.rb 

# Step 9: Update the crontab using whenever. This updates the crontab of the user using the schedule.rb file
echo "Creating cronjob from schedule.rb..."
whenever --update-crontab

# Step 10: Check the crontab for the created job to run the Ruby file
echo "Opening crontab for the user..."
crontab -l
echo "Please check the crontab above. This should indicate that the cronjob was added to the user's crontab."

# Step 11: Let the script wait for 3 minutes to wait for the program to be ran by the cron job.
echo "The program will now automatically wait for 3 minutes before proceeding. You do not have to do anything else. Thank you!"
sleep 180

# Step 12: Open the log file on the browser again to see the log entry created after the cronjob ran the program.
echo "Opening html log file. You can refresh the browser to check if the program is still running."
google-chrome logs/selenium_log.html
echo "You can now open the README.md file. You can also test the code itself by changing the variables. Thank you and have a great day!"
