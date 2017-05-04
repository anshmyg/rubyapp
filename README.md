# Simple Rupy app with ansible-playbook and capistrano 
This app just shows your ip address and user agent.
Playbook is located in the directory `ansible_pb`. 

Ansible-playbook installs:

- Ruby 2.3.3p222   
- nginx
- Puma (jungle)

1. Change the app name, deploy directory and user name for deploy in <code>ansible_pb/vars/defaults.yml</code>.
2. Put correct ip address in `ansible_pb/hosts`.

To run:

    $ ansible-playbook -i hosts ruby-webapp.yml -t ruby,deploy,nginx
    $ <deploy this app with capistrano file from this repo>
    $ ansible-playbook -i hosts ruby-webapp.yml -t puma

There is an example Capistrano `config/deploy.rb` in this repository that you can use for deployment.
Capistrano downloads ruby app from this repo and install it at your server. Don't foget to put correct ip address in `config/deploy.rb` and put ssh key on production server.

This app was tested only on Ubuntu Server 14.04 LTS.
