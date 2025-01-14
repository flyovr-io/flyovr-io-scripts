# flyovr.io feed client

- These scripts aid in setting up your current ADS-B receiver to feed [flyovr.io](https://flyovr.io/).
- This will not disrupt any existing feed clients already present.
- When setting up new feeders, a decoder such as [readsb](https://github.com/wiedehopf/adsb-scripts/wiki/Automatic-installation-for-readsb) must be installed separately.

## 1: Find antenna coordinates and elevation

<https://www.freemaptools.com/elevation-finder.htm>

## 2: Install the feed client

```
curl -L -o /tmp/feed.sh https://install.flyovr.io/
sudo bash /tmp/feed.sh
```

## 3: Use netstat to check that your feed is working
The feed IP for flyovr.io is 54.197.249.111

```
netstat -t -n | grep -E '30004|31090'
```
Expected Output:
```
tcp        0    182 localhost:71669     54.197.249.111:31090      ESTABLISHED
tcp        0    410 localhost:12772     54.197.249.111:30004      ESTABLISHED (MLAT is not up as of 8/8/23 so this will not be present in netstat)
```

## 4: Optional: Install [local interface](https://github.com/wiedehopf/tar1090) for your data

The interface will be available at http://192.168.X.XX/flyovrio 
Replace the IP address with the address of your Raspberry Pi.

Install / Update:
```
sudo bash /usr/local/share/flyovrio/git/install-or-update-interface.sh
```
Remove:
```
sudo bash /usr/local/share/tar1090/uninstall.sh flyovrio
```

### Update the feed client without reconfiguring

```
curl -L -o /tmp/update.sh https://raw.githubusercontent.com/flyovr-io/flyovr-io-scripts/master/update.sh
sudo bash /tmp/update.sh
```

### If you encounter issues, please do a reboot and then supply these logs on Discord (last 20 lines for each is sufficient):

```
sudo journalctl -u flyovrio-feed --no-pager
sudo journalctl -u flyovrio-mlat --no-pager
```

### Display the configuration

```
cat /etc/default/flyovrio
```

### Changing the configuration

This is the same as the initial installation.
If the client is up to date it should not take as long as the original installation,
otherwise this will also update the client which will take a moment.

```
curl -L -o /tmp/feed.sh https://raw.githubusercontent.com/flyovr-io/flyovr-io-scripts/master/install.sh
sudo bash /tmp/feed.sh
```

### Disable / Enable flyovr.io MLAT-results in your main decoder interface (readsb / dump1090-fa)

This is enabled by default. You probably don't need to change that.

- Disable:

```
sudo sed --follow-symlinks -i -e 's/RESULTS=.*/RESULTS=""/' /etc/default/flyovrio
sudo systemctl restart flyovrio-mlat
```
- Enable:

```
sudo sed --follow-symlinks -i -e 's/RESULTS=.*/RESULTS="--results beast,connect,127.0.0.1:30104"/' /etc/default/flyovrio
sudo systemctl restart flyovrio-mlat
```

### Restart the feed client

```
sudo systemctl restart flyovrio-feed
sudo systemctl restart flyovrio-mlat
```

### Show status

```
sudo systemctl status flyovrio-feed
sudo systemctl status flyovrio-mlat
```

### Removal / disabling the services

```
sudo bash /usr/local/share/flyovrio/uninstall.sh
```

If the above doesn't work, you can just disable the services and the scripts won't run anymore:

```
sudo systemctl disable --now flyovrio-feed
sudo systemctl disable --now flyovrio-mlat
```
