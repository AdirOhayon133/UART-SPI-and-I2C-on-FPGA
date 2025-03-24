
# UART, SPI And I2C Protocols on FPGA

UART, SPI And I2C protocols implemented on FPGA in Vivado design software with VHDL.

In this project, popular communication protocols are designed on FPGA, each for a specific application.

This project uses the PYNQ development board by TUL, based on the AMD (Xilinx) Zynq 7020 SoC (FPGA + ARM processor).

## By: Adir Ohayon

---

## 1. UART

### Introduction
Universal Asynchronous Receiver Transmitter (UART) is a serial asynchronous communication protocol. 

Data transfer occurs in frames, which include:
- Start bit
- 5, 6, 7, or 8 data bits
- Stop bit
- Optional parity bit

The baud rate must be the same for the receiver and transmitter, commonly 9600 or 115200 bps.
![image](https://github.com/user-attachments/assets/ad2cf0e8-3720-428b-9099-3e8847bc0827)
![image](https://github.com/user-attachments/assets/ebd2d331-6e61-4ef0-b82e-6f6dffe6d679)

LSB is the first bit to transfer.

### Application
This project implements a UART receiver that connects to a Bluetooth HC-05 module. The HC-05 sends ASCII codes from a tablet, and the receiver displays the ASCII code using LEDs.

#### VHDL Code Explanation
- **Clock Divider**: Generates a 9600Hz clock from a 125MHz system clock.
- **State Machine Implementation**: 
  - Detects start bit
  - Reads 8-bit data from HC-05
  - Displays data on LEDs
 
![image](https://github.com/user-attachments/assets/88e385ed-1680-414e-9ed5-f9f762050356)

#### Simulation
- Uses a test bench for verification.
  
![image](https://github.com/user-attachments/assets/a3800823-1c38-4efd-b657-66761197f01d)

#### Results
- ASCII Code for `A` (01000001) sent and received.
  ![image](https://github.com/user-attachments/assets/10840b89-54c1-436f-91f8-702ae3a9d15d)

  ![image](https://github.com/user-attachments/assets/423d8d65-cb9d-4715-ab9a-71429d419fec)

- ASCII Code for `z` (01111010) sent and received.
  ![image](https://github.com/user-attachments/assets/3242a540-7df3-4344-867f-e7e956dc0051)

  ![image](https://github.com/user-attachments/assets/847b26b8-00ae-41d9-8ba7-0ee72194c387)

#### Hardware Connection
The HC-05 module connects to the PYNQ development board using PMOD GPIO connectors. Received data is displayed via 8 external LEDs.

## 2. SPI

### Introduction
Serial Peripheral Interface (SPI) is a synchronous communication protocol where the transmitter and receiver use the same clock signal.

SPI uses four wires:
1. **SCK** – Clock signal from master to slave
2. **CS** – Chip Select
3. **MOSI** – Master Out Slave In
4. **MISO** – Master In Slave Out

![image](https://github.com/user-attachments/assets/da26379d-39fb-4a35-a6aa-ad1796ab8066)

#### SPI Data Transfer Process
- Master sends a clock signal via SCK.
- Master lowers CS and starts sending data via MOSI.
- Slave may respond via MISO.
- After transmission, master raises CS.

![image](https://github.com/user-attachments/assets/24aeeedc-730f-4c1e-ba50-305e44e8e472)

### Application
This project implements an SPI master to control an MCP4921 12-bit DAC.

![image](https://github.com/user-attachments/assets/0366916e-452f-45a1-9fce-7093503a8b0f)

The first 4 bits are the configuration command, then the 12 bits of data, MSB sending first.
The analog voltage by theory calculation:

$$V_{out} = \frac{V_{ref} \times D(11:0)}{4096}$$

#### VHDL Code Explanation
- **Clock Divider**: Generates a 1MHz SPI clock from a 125MHz system clock.
- **State Machine Implementation**:
  - Sends configuration and 12-bit data to MCP4921
  - Converts digital values to analog signals

![image](https://github.com/user-attachments/assets/60d54bd0-ebdb-428c-917a-c08aee04a56d)

#### Simulation
- Uses a test bench to verify data transmission.

![image](https://github.com/user-attachments/assets/19057182-721b-47cc-b743-0a31eb6470d5)

#### Results
| Data Sent | Analog Voltage |
|-----------|---------------|
| 001000000000 | 0.42V |
| 011111111111 | 1.67V |

Measured values match theoretical calculations with minor bias.

![image](https://github.com/user-attachments/assets/d62b3c64-ab6d-4be4-8083-54776a6049a3)


![image](https://github.com/user-attachments/assets/0ff3eb71-433c-40ee-9ccc-47ab4edef9cb)


![image](https://github.com/user-attachments/assets/5a36b59c-5e7f-42a9-8343-9a19026d6fac)


![image](https://github.com/user-attachments/assets/d2f0a1d4-16b4-41c1-abc5-535cc4606a0e)


#### Hardware Connection
The MCP4921 DAC connects to the PYNQ development board via PMOD GPIO connectors.

## 3. I2C

### Introduction
Inter-Integrated Circuit (I2C) is an 8-bit oriented synchronous serial communication protocol using two wires:
1. **SCL** – Serial Clock
2. **SDA** – Serial Data

![image](https://github.com/user-attachments/assets/548d7555-a5ee-4096-86aa-0d2ff31e6159)

#### I2C Data Transfer Process
- Both SCL and SDA lines are initially high.
- Master generates a **START** signal by pulling SDA low while SCL is high.
- Master sends a 7-bit address and a read/write bit.
- Communication occurs in data frames with acknowledge bits.
- Master generates a **STOP** signal by pulling SDA high while SCL is high.

![image](https://github.com/user-attachments/assets/e16f30ab-d4a0-4228-8a00-ba181b0bbcf1)

![image](https://github.com/user-attachments/assets/596a101c-1c8d-4532-922f-9f149c3f4018)

### Application
This project implements an I2C master to interface with an LM75 temperature sensor.

#### Temperature Calculation
- If the sign bit is positive, the result is:

$$ T(°C) = D(9:0) \times 0.125 $$  

- If the sign bit is negative, the result is:

$$ T(°C) = ( \text{Two's complement of } D(9:0) ) \times 0.125 $$  

#### VHDL Code Explanation
- **Clock Divider**: Generates a 100KHz SCL signal.
- **State Machine Implementation**:
  - Reads temperature data from LM75.
  - Updates temperature reading every second.
 
![image](https://github.com/user-attachments/assets/a992ad0c-5dd8-461d-a8da-080306b84ad7)

#### Simulation
- Uses a test bench to verify temperature readings.

![image](https://github.com/user-attachments/assets/b3f215d6-0d39-4dbd-88dd-c8359c689ed9)


#### Results
- Measured temperature: **31.25°C**

![image](https://github.com/user-attachments/assets/3ba0544d-4051-4781-9bc0-56e02c44e08e)

The MSB is the sign bit. Since it is 0, the temperature is positive.

$$ T(°C) = 250 \times 0.125 = 31.25^\circ $$

#### Hardware Connection
The LM75 sensor connects to the PYNQ development board via PMOD GPIO connectors. The temperature data updates 11 external LEDs every second.

---

## Summary
This project successfully implements UART, SPI, and I2C communication protocols on an FPGA using VHDL. The results confirm accurate data transmission and processing.
