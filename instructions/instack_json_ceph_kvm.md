##Copy and paste from jq . to the end of the doc into the console of undercloud as user stack.

jq . << EOF > ~/instackenvceph.json
{
  "ssh-user": "root",
  "ssh-key": "$(cat ~/.ssh/id_rsa)",
  "power_manager": "nova.virt.baremetal.virtual_power_driver.VirtualPowerManager",
  "host-ip": "192.168.1.119",
  "arch": "x86_64",
  "nodes": [
    {
      "pm_addr": "192.168.1.119",
      "pm_password": "$(cat ~/.ssh/id_rsa)",
      "pm_type": "pxe_ssh",
      "mac": [
        "$(sed -n 1p /tmp/cephnodes.txt)"
      ],
      "cpu": "1",
      "memory": "4096",
      "disk": "100",
      "arch": "x86_64",
      "pm_user": "root"
    },
    {
      "pm_addr": "192.168.1.119",
      "pm_password": "$(cat ~/.ssh/id_rsa)",
      "pm_type": "pxe_ssh",
      "mac": [
        "$(sed -n 2p /tmp/cephnodes.txt)"
      ],
      "cpu": "4",
      "memory": "4096",
      "disk": "100",
      "arch": "x86_64",
      "pm_user": "root"
    },
    {
      "pm_addr": "192.168.1.119",
      "pm_password": "$(cat ~/.ssh/id_rsa)",
      "pm_type": "pxe_ssh",
      "mac": [
        "$(sed -n 3p /tmp/cephnodes.txt)"
      ],
      "cpu": "4",
      "memory": "4096",
      "disk": "100",
      "arch": "x86_64",
      "pm_user": "root"
    },
    {
      "pm_addr": "192.168.1.119",
      "pm_password": "$(cat ~/.ssh/id_rsa)",
      "pm_type": "pxe_ssh",
      "mac": [
        "$(sed -n 4p /tmp/cephnodes.txt)"
      ],
      "cpu": "1",
      "memory": "4096",
      "disk": "100",
      "arch": "x86_64",
      "pm_user": "root"
    }
  ]
}
EOF
