### Setup

Install CachyOS 
- Load ISO onto Ventroy 
- Setup for Gaming - https://wiki.cachyos.org/configuration/gaming/
- Install Docker Desktop - https://docs.docker.com/desktop/setup/install/linux/archlinux/
    - Setup pass `pass init <email@address.com>`
- Install 1Password Desktop - https://support.1password.com/install-linux/#arch-linux
    - Setup SSH Agent


### DNS
Create /etc/NetworkManager/conf.d/use-dnsmasq.conf
``` 
sudo touch /etc/NetworkManager/conf.d/use-dnsmasq.conf
sudo nano /etc/NetworkManager/conf.d/use-dnsmasq.conf
```
Update with
```
[main]
dns=dnsmasq
```
Create/etc/NetworkManager/dnsmasq.d/local.conf
``` 
sudo touch /etc/NetworkManager/dnsmasq.d/local.conf
sudo nano /etc/NetworkManager/dnsmasq.d/local.conf
```
Update with
```
address=/.local.pixeloven.com/127.0.0.1
```

then run
```
sudo systemctl restart NetworkManager
```