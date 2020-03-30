# task-manager
A task manager written in Ruby

Heroku deployment: potato-taskmanager.herokuapp.com (not fully deployed)

**How to run this project on your computer**

Firstly, clone this repo to your workspace and install gems (with bundle install).

>$ git clone https://github.com/ming-00/task-manager

>$ cd task-manager

>$ bundle install --without production

Then, run migrations.
>$ rails db:migrate

Finally, run rails server.
>$ rails server

Open http://localhost:3000 on server.

Mail preview at http://localhost:3000/rails/mailers/user_mailer

Currently working on the issue of email authentication
