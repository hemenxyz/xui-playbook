---
- name: Install XUI with SSL
  hosts: all
  become: yes
  vars:
    custom_domain: "{{ custom_domain }}"  
  tasks:
    - name: Run the Bash Command
      shell: "bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)"
    
    - name: Install core via Snap
      shell: "snap install core; snap refresh core"
    
    - name: Install Certbot via Snap (Classic)
      shell: "snap install --classic certbot"
    
    - name: Create Symbolic Link for Certbot
      shell: "ln -s /snap/bin/certbot /usr/bin/certbot"
    
    - name: Obtain Let's Encrypt SSL Certificate
      shell: "certbot certonly --standalone --register-unsafely-without-email --non-interactive --agree-tos -d {{ custom_domain }}"
