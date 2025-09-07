# PPPwn-Luckfox
An alternative method to [0x1iii1ii/PPPwn-Luckfox](https://github.com/0x1iii1ii/PPPwn-Luckfox) running PPPwn on Luckfox Pico Plus/Pro/Max with additional features.

## Features
- Hosts a web interface for configuring PPPwn, running pppwn and hosting payloads.
- Starts a PPPoE server to assign IP addresses to PS4.
- Supports PS4 firmware versions 9.00, 9.03, 9.04, 9.50, 9.51, 9.60, 10.00, 10.01, 10.50, 10.70, 10.71 & 11.00.
- Supports both HEN and GoldHEN, can be configured via config page.
- Supports auto run on boot can be turned on/off via config page (Note: It's off by default).
- Supports Buildroot(NAND/SD) and Ubuntu(SD only).
- Supports GoldHen detect feature, if the GoldHen is detected it skips running the PPPwn.

## Prerequisites
- Luckfox Pico device
- An SD card 8GB or above (optional)
- Ethernet and Type-C cables
- USB drive (for GoldHEN/Hen)
- PC (for setup and flashing OS onto the SD card/NAND)

## Downloads
   ### Custom Buildroot/Ubuntu Image for PPPwn-Luckfox
   Luckfox Model | Buildroot NAND Image | Buildroot SD Image | Ubuntu Image
   ------------- | ------------- | ------------- | -------------
   Luckfox Pico Pro/Max | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.1.5/Buildroot_NAND_Pro_Max.rar) | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.1.5/Buildroot_SD_Pro_Max.rar) | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.0/Luckfox.pico.pro-max.img.rar)
   Luckfox Pico Plus/Mini | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.1.5/Buildroot_NAND_Plus.rar) | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.1.5/Buildroot_SD_Plus.rar) | [download](https://github.com/harsha-0110/PPPwn-Luckfox/releases/download/v1.0/Luckfox.pico.plus.img.rar)

   ### SocToolKit for flashing image into SD card
   - [SocToolKit](https://files.luckfox.com/wiki/Luckfox-Pico/Software/SocToolKit.zip)
   - [DriverAssitant-RK](https://files.luckfox.com/wiki/Luckfox-Pico/Software/DriverAssitant_v5.12.zip)

   ### Mobaxterm
   - [Mobaxterm](https://download.mobatek.net/2422024061715901/MobaXterm_Portable_v24.2.zip)


## Installation
### Buildroot(NAND/SD) Installation (Windows)
1. Download the Buildroot(NAND/SD) image for your respective Luckfox Pico Model, SocToolKit from above and extract them. If you want to install on NAND, download and install DriverAssitant-RK.

2. Follow this [SD tutorial](https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-SD-Card-burn-image) to flash the OS onto the SD card for the Luckfox. Or this [NAND tutorial](https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-Flash-burn-image) to flash the OS onto the NAND of the Luckfox.

3. Skip this step if you are installing on the NAND. After flashing the OS, eject the SD card and insert it into the Luckfox.

4. Now connect Luckfox device to PC via Type-C cable.

5. On your PC open `Control Panel -> Network and Internet -> Network and Sharing Center -> Change Adapter Options`. You will find `Remote NDIS based Internet Sharing Device`. Right-click and choose Properties.

6. Double-click on `Internet Protocol Version 4 (TCP/IPv4)`. Set the IPv4 address to `172.32.0.100` and click on subnet mask and click OK.

7. Open MobaXterm, choose Session->SSH, and enter the IP address of Luckfox pico as `172.32.0.93` and click OK, enter login `root` and password `luckfox`.

8. Download this repo, unzip and rename folder to `PPPwn-Luckfox` drag and drop the files into `/root` in the Mobaxterm SSH browser(SSH files viewer).

9. Run the following commands in SSH:
   ```sh
   cd PPPwn-Luckfox
   chmod +x install.sh
   ./install.sh
   ```

10. After Reboot you can visit `http://172.32.0.93/` using any browser to access the web-ui and modify the config.

### Buildroot  Installation (MacOS) - ***ATTENTION - NAND ONLY!!!***
1. Download the Buildroot NAND image for your respective Luckfox Pico Model, SocToolKit from above and extract them.

2. Grab your self a copy of [upgrade tool v2.25 for mac](https://wiki.luckfox.com/Luckfox-Pico/Linux-MacOS-Burn-Image/#burning-in-macos-environment) and [android platform tools](https://developer.android.com/tools/releases/platform-tools).

3. Plug your luckfox into usb while holding the boot button and on your mac's terminal, check that your board is listed:
    ```
    sudo /path/to/upgrade_tool ld
    ```

4. To upgrade your firmware, we just need the update.img from the custom buildroot:
    ```
    sudo /path/to/upgrade_tool uf /path/to/update.img
    ```

5. We can check when the device finished rebooting by checking for presence in adb:
    ```
    adb wait-for-device && adb devices
    ```

6. Send the necessary files into the correct path:
    ```
    adb push /path/to/extracted-PPPwn-Luckfox /root/PPPwn-Luckfox
    ```

7. Grab a shell from the device and start installation:
    ```
    adb shell
    ````

8. In Luckfox shell (`[root@luckfox ]$`), run the following commands:
    ```
    cd /root/PPPwn-Luckfox/
    chmod +x install.sh
    ./install.sh
    ```

### Ubuntu SD Installation (Windows)
1. Download the Ubuntu image for your respective Luckfox Pico Model, SocToolKit from above and extract them.

2. Follow this [tutorial](https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-SD-Card-burn-image) to flash the OS onto the SD card for the Luckfox.

3. After flashing the OS, eject the SD card and insert it into the Luckfox. Plug the Type-C cable into the Luckfox to power it up and connect one end of the Ethernet cable to the Luckfox and the other end to a router.

4. Log in to the Luckfox using SSH, the ip address of the LuckFox Pico device can be obtained from Router's admin page or using network tools like Fing:
    ```sh
    Login: pico
    Password: luckfox
    ```

5. Run the following commands in SSH:
   ```sh
   sudo git clone -b Ubuntu https://github.com/harsha-0110/PPPwn-Luckfox.git
   cd PPPwn-Luckfox
   sudo chmod +x install-dep.sh install.sh
   sudo ./install-dep.sh
   sudo ./install.sh
   ```

6. After Reboot you can visit `http://172.32.0.70/` using any browser to access the web-ui and modify the config.

## Web Interface Features
The web interface is available at `http://<your-device-ip>/` and `http://10.1.1.1/` on PS4 using PPPoE connection.
- `index.php`: Web-UI dashboard.
- `Run PPPwn`: This button in the dashboard allows you to start PPPwn execution from the browser.
- `Shutdown`: This button in the dashboard allows you to turn-off the Luckfox device from the browser.
- `eth0 off`: This button in the dashboard allows you to turn-off the Luckfox's ethernet port from the browser.
- `config.php`: Allows you to configure PPPwn.
- `900/index.html`: Hosts PS4 fw 9.00 payloads.
- `1100/index.html`: Hosts PS4 fw 11.00 payloads.
- `all/index.html`: Hosts PS4 payloads that work on all fw upto 11.50.
- `linux/index.html`: Hosts Linux payloads for PS4 phat and slim.
- `linux-pro/index.html`: Hosts Linux payloads for PS4 pro.

## Configuration
### Web Interface
The Config page is available at `http://<your-device-ip>/config.php` and `http://10.1.1.1/config.php` on PS4 using PPPoE connection

### Manual Configuration
You can manually edit the configuration file located at `/etc/pppwn/config.ini`.

## Usage

### Running PPPwn
- Automatically runs at the start of the Luckfox (can be turned on/off from config page, off by default).
- Can also be started manually from `index.php` by clicking the `Run PPPwn` button.

## Update
### Update Ubuntu:
To update the project with the latest changes from the repository:

1. Run the update script:
   ```sh
   cd PPPwn-Luckfox
   sudo ./update.sh
   ```

## PS4 Setup:
- Go to `Settings` and then `Network`.
- Select `Set Up Internet connection` and choose `Use a LAN Cable`.
- Choose `Custom` setup and choose `PPPoE` for `IP Address Settings`.
- Enter `ppp` for `PPPoE User ID` and `PPPoE Password`.
- Choose `Automatic` for `DNS Settings` and `MTU Settings`.
- Choose `Do Not Use` for `Proxy Server`.

## Notes
- This repo is a work in progress and may contain bugs.
- Tested on Luckfox Pico Pro.
- Ubuntu Installation takes about 10-15 minutes on pro model may take longer on plus model.

## Contributing
Feel free to submit issues or pull requests for improvements and bug fixes.

## Credits
Special Thanks to
- [TheOfficialFloW](https://github.com/TheOfficialFloW) for PPPwn Exploit.
- [Xfangfang](https://github.com/xfangfang) for PPPwn C++ port.
- [Sistro](https://github.com/SiSTR0) for GoldHEN.
- [EchoStrech](https://github.com/EchoStretch) and [BestPig](https://x.com/BestPig) for HEN ports.
- [0x1iii1ii](https://github.com/0x1iii1ii) for the inspiration for PPPwn-Luckfox.
- [keschort](https://github.com/keschort) for the kernel config for Luckfox Pico.
- [nn9dev](https://github.com/nn9dev) for the updated PPPwn_cpp with additional arguments.
- [rdmrocha](https://github.com/rdmrocha) for his contribution.
- And to all the Dev's in PS4 Scene.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.
