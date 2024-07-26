# PPPwn-Luckfox

An alternative method to [0x1iii1ii/PPPwn-Luckfox](https://github.com/0x1iii1ii/PPPwn-Luckfox) running PPPwn on Luckfox Pico Mini/Plus/Pro/Max with additional features.

## Features

- Automates the installation of required services and configurations.
- Hosts a web interface for configuring PPPwn and hosting payloads.
- Starts a PPPoE server to assign IP addresses to PS4.
- Supports PS4 firmware versions 9.00, 10.00, 10.01 & 11.00.
- USB emulation with goldhen.bin (not tested).

## Prerequisites

- Luckfox Pico device
- An SD card (8GB or above)
- Ethernet and Type-C cables
- USB drive (for GoldHEN)
- PC (for flashing OS onto the SD card)

## Installation

1. Follow this [tutorial](https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-quick-start) to flash the OS onto the SD card for the Luckfox.

2. After flashing the OS, eject the SD card and insert it into the Luckfox. Plug the Type-C cable into the Luckfox to power it up and connect one end of the Ethernet cable to the Luckfox and the other end to a router.

3. Log in to the Luckfox using SSH:
    ```sh
    Login: pico
    Password: luckfox
    ```

4. Run the following commands in SSH:
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

- Automatically runs at the start of the Luckfox.
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
- Emulate a USB drive with `goldhen.bin`(Implemented and need to be tested).
- Emulate a USB drive with `payload.bin` in conjunction with Lightining Mods stage2 payload loader.

## Contributing

Feel free to submit issues or pull requests for improvements and bug fixes.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
