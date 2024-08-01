# PPPwn-Luckfox

An alternative method to [0x1iii1ii/PPPwn-Luckfox](https://github.com/0x1iii1ii/PPPwn-Luckfox) running PPPwn on Luckfox Pico Plus/Pro/Max with additional features.

## Features

- Automates the installation of required services and configurations.
- Hosts a web interface for configuring PPPwn and hosting payloads.
- Starts a PPPoE server to assign IP addresses to PS4.
- Supports PS4 firmware versions 9.00, 9.03, 9.04, 9.50, 9.51, 9.60, 10.00, 10.01, 10.50, 10.70, 10.71 & 11.00.

## Prerequisites

- Luckfox Pico device
- An SD card (8GB or above)
- Ethernet and Type-C cables
- USB drive (for GoldHEN/Hen)
- PC (for flashing OS onto the SD card)

## Downloads
   ### Ubuntu Image 
   Luckfox Model  | Image
   ------------- | -------------
   Luckfox Pico Pro/Max  | [download]()
   Luckfox Pico  | [download]()

   - SocToolKit [download](https://files.luckfox.com/wiki/Luckfox-Pico/Software/SocToolKit.zip)

## Installation
1. Download the Ubuntu image for your respective Luckfox Model from above.

2. Follow this [tutorial](https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-quick-start) to flash the OS onto the SD card for the Luckfox.

3. After flashing the OS, eject the SD card and insert it into the Luckfox. Plug the Type-C cable into the Luckfox to power it up and connect one end of the Ethernet cable to the Luckfox and the other end to a router.

4. Log in to the Luckfox using SSH:
    ```sh
    Login: pico
    Password: luckfox
    ```

5. Run the following commands in SSH:
   ```sh
   sudo apt install git
   sudo git clone https://github.com/harsha-0110/PPPwn-Luckfox.git
   cd PPPwn-Luckfox
   sudo chmod +x install.sh
   sudo ./install.sh
   ```

## Configuration

### Web Interface

The web interface is available at `http://<your-device-ip>/`.
- `index.php`: Web-UI dashboard.
- `config.php`: Allows you to configure PPPwn.
- `payloads.html`: Hosts various payloads.

### Manual Configuration

You can manually edit the configuration file located at `/etc/pppwn/config.json`.

## Usage

### Running PPPwn

- Automatically runs at the start of the Luckfox (can be turned on/off from config page, off by default).
- Can also be started manually from `index.php` by clicking the `Run PPPwn` button.

## Update

To update the project with the latest changes from the repository:

1. Run the update script:
   ```sh
   sudo ./update.sh
   ```

## Notes
- This repo is a work in progress and has not been tested on a Luckfox Pico.

## Future Plans
- Update the payloads page to host payloads for supported firmware.

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

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
