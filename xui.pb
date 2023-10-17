---
- name: Install XUI with SSL
  hosts: all
  become: yes
  vars:
    panel_domain: "{{ panel_domain }}"
    panel_username: "{{ panel_username | default('admin') }}"
    panel_password: "{{ panel_password | default('xuipassword') }}"
    panel_port: "{{ panel_port | default('5678') }}"
  tasks:
    - name: Run the Bash Command
      expect:
        command: "curl -o install.sh https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh && chmod +x install.sh && ./install.sh"
        responses:
          "Do you want to continue with the modification [y/n]?": "y\n"
          "Please set up your username:": "{{ panel_username }}\n"
          "Please set up your password:": "{{ panel_password }}\n"
          "Please set up the panel port:": "{{ panel_port }}\n"
      register: script_output
      changed_when: false

    - name: Install core via Snap
      shell: "snap install core; snap refresh core"

    - name: Install Certbot via Snap (Classic)
      shell: "snap install --classic certbot"

    - name: Create Symbolic Link for Certbot
      shell: "ln -s /snap/bin/certbot /usr/bin/certbot"

    - name: Obtain Let's Encrypt SSL Certificate
      shell: "certbot certonly --standalone --register-unsafely-without-email --non-interactive --agree-tos -d {{ custom_domain }}"
