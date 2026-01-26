network:
  version: 2
  ethernets:
    NM-58284143-8cec-374a-a704-c70fcc9650b4:
      renderer: NetworkManager
      match:
        name: "enp0s3"
      addresses:
      - "192.168.10.40/24"
      nameservers:
        addresses:
        - 192.168.10.40
