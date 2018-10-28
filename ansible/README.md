OCEMR Role
==========

OCEMR Appliance Configuration Role

Requirements
------------

None that I know of.

Role Variables
--------------

### Database configuration
Leave the host and port empty to use the local socket.
* `db_user: ocemr`
* `db_password: ocemr`
* `db_host:`
* `db_port:`
* `db_admin_password: changeme`

### Application configuration
Options from the [OCEMR](https://github.com/ph1l/ocemr) settings.py
* `ocemr_debug: False`
* `server_email: ocemr@server.com`
* `printer_name: Some_CUPS_Printer`
* `timezone: America/Chicago`

Example Inventory
-----------------

```
    - hosts: localhost
      connection: local
      roles:
          - ocemr
      vars:
          - db_admin_password: supersecretpassword
          - ocemr_debug: False
```

Usage
-----

    # git clone https://github.com/patfreeman/ocemr_ansible.git ocemr
    # vi ocemr.yml # Insert Example Inventory and edit to liking with Role Variables
    # ansible-playbook ocemr.yml
