> Execute commands from `/ansible` directory

## Verify Inventory & SSH Connectivity

- ### Verify Whole Inventory

  ```bash
  ansible -i inventory/<file_name_inventory.yaml> all -m ping
  ```

- ### Verify Specific Host

  ```bash
  ansible -i inventory/<file_name_inventory.yaml> <host-name> -m ping
  ```

## Run Playbooks

- ### Run Playbook with sudo (become)

  > When playbooks require become, you will be prompted for the sudo (become) password.

  ```bash
  ansible-playbook -i inventory/<file_name_inventory.yaml> \
  playbooks/<file_name_playbook.yaml> \
  -K
  ```

- ### Run Playbook (default target)

  ```bash
  ansible-playbook -i inventory/<file_name_inventory.yaml> \
  playbooks/<file_name_playbook.yaml>
  ```

- ### Run Playbook Using `target` Variable

  Playbook must have:

  - Variable with fallback: `hosts: "{{ target | default('<fallback_group_name') }}"`

  ```bash
  ansible-playbook -i inventory/<file_name_inventory.yaml> \
  playbooks/<file_name_playbook.yaml> \
  -e "target=<host-name>"
  ```
