# UART, SPI, and I2C Protocols on FPGA

UART, SPI, and I2C protocols implemented on FPGA using Vivado design software with VHDL.

In this project, popular communication protocols are designed on FPGA, each for a specific application.

This project uses the **PYNQ development board** by **TUL**, which is based on the **AMD (Xilinx) Zynq 7020 SoC (FPGA + ARM processor).**

## Author: Adir Ohayon

---

## 1. UART

### Introduction
**Universal Asynchronous Receiver Transmitter (UART)** is a serial asynchronous communication protocol.

**Data transfer occurs in frames**, which include:
- Start bit
- 5, 6, 7, or 8 data bits
- Stop bit
- Optional parity bit

The **baud rate** must be the same for the receiver and transmitter, commonly **9600 or 115200 bps**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ad2cf0e8-3720-428b-9099-3e8847bc0827" width="600">
</p>
<p align="center">1. UART connection between 2 devices</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/ebd2d331-6e61-4ef0-b82e-6f6dffe6d679" width="600">
</p>
<p align="center">2. UART data transfer</p>

LSB is the first bit to transfer.

### Application
This project implements a **UART receiver** that connects to a **Bluetooth HC-05 module**. The HC-05 sends ASCII codes from a tablet, and the receiver displays the ASCII code using LEDs.

### **VHDL Code Explanation**
This VHDL code implements a simple UART receiver that converts serial data into an 8-bit parallel output. It operates using a 125 MHz clock and generates a lower 9600 Hz clock for sampling the incoming data.

The module begins by defining its inputs and outputs, including the high-frequency clock, a reset signal, a serial data input (`Din`), and an 8-bit output (`Dout`). A counter is used to divide the 125 MHz clock down to 9600 Hz, which is necessary for UART communication.

A finite state machine (FSM) is used to control the reception process. The system starts in an idle state (`start_stop`), where it waits for a low signal (`Din = 0`), indicating the start of data transmission. Once detected, the FSM transitions to the `Datain` state and begins capturing incoming bits at the 9600 Hz clock rate.

Each bit is stored sequentially in the `Dout` register, indexed by `data_index`, which increments with each received bit. After all 8 bits are received, the FSM returns to the idle state (`start_stop`), ready for the next transmission.

This design ensures reliable data reception by synchronizing with the incoming serial data and properly assembling it into an 8-bit parallel format.

<p align="center">
  <img src="https://github.com/user-attachments/assets/88e385ed-1680-414e-9ed5-f9f762050356" width="600">
</p>
<p align="center">3. State-Machine to implement the UART receiver</p>

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a3800823-1c38-4efd-b657-66761197f01d" width="600">
</p>
<p align="center">4. Reciver simulation</p>

#### **Results**
- **ASCII Code for `A` (01000001) sent and received:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/10840b89-54c1-436f-91f8-702ae3a9d15d" width="500">
</p>
<p align="center">5. Sending A</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/423d8d65-cb9d-4715-ab9a-71429d419fec" width="500">
</p>
<p align="center">6. Received A</p>

- **ASCII Code for `z` (01111010) sent and received:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/3242a540-7df3-4344-867f-e7e956dc0051" width="500">
</p>
<p align="center">7. Sending z</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/847b26b8-00ae-41d9-8ba7-0ee72194c387" width="500">
</p>
<p align="center">8. Received z</p>

#### **Hardware Connection**
The HC-05 module is connected to the **PYNQ development board** using **PMOD GPIO connectors**. The received data is displayed via **8 external LEDs**.

---

## 2. SPI

### Introduction
**Serial Peripheral Interface (SPI)** is a synchronous communication protocol where the transmitter and receiver share the same clock signal.

**SPI uses four wires:**
1. **SCK** – Clock signal from master to slave.
2. **CS** – Chip Select.
3. **MOSI** – Master Out Slave In.
4. **MISO** – Master In Slave Out.

<p align="center">
  <img src="https://github.com/user-attachments/assets/da26379d-39fb-4a35-a6aa-ad1796ab8066" width="300">
</p>
<p align="center">9. SPI protocol wires</p>

#### **SPI Data Transfer Process**

- The **master** sends a clock signal via **SCK**.
- The **master** lowers **CS** and starts sending data via **MOSI**.
- The **slave** may respond via **MISO**.
- The transmission ends when the **master** raises **CS**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/24aeeedc-730f-4c1e-ba50-305e44e8e472" width="600">
</p>
<p align="center">10. SPI data transfer process</p>

### Application
This project implements an **SPI master** to control an **MCP4921 12-bit DAC**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0366916e-452f-45a1-9fce-7093503a8b0f" width="600">
</p><p align="center">11. MCP4921 pinout</p>


**Voltage Calculation Formula:**

$$V_{out} = \frac{V_{ref} \times D(11:0)}{4096}$$

### VHDL Code Explanation
This VHDL module implements an SPI Master to communicate with a Digital-to-Analog Converter (DAC). It generates three essential SPI signals: `MOSI` (Master Out, Slave In), `SCLK` (Serial Clock), and `CS` (Chip Select). The system operates using a 125 MHz input clock, which is divided down to generate an appropriate SPI clock.

The module follows a finite state machine (FSM) approach with three states:

1. Idle (`st_idle`) – The system remains inactive until `tx_enable` is asserted. In this state, `CS` is high (inactive), and `MOSI` is low.

2. Control Transmission (`st0_txmt`) – When transmission starts, `CS` is pulled low to activate the DAC. The module sends a 4-bit control sequence (`0011`).

3. Data Transmission (`st1_txmt`) – After sending the control bits, the system transmits a 12-bit data value (`010000000000`). Once transmission is complete, the system returns to the idle state (`st_idle`).

A clock division process reduces the 125 MHz input clock to generate an appropriate SPI clock (`SCLK`). The clock toggles after 62 cycles to ensure correct SPI timing. The FSM transitions between states based on the `tx_enable` signal and the data index counter.

This design ensures reliable SPI communication by sequencing the control and data bits properly while maintaining accurate clock timing. It is ideal for FPGA-based DAC control applications.
 
  <p align="center">
  <img src="https://github.com/user-attachments/assets/46c4d564-0929-4052-a563-d94ea0b37035" width="600">
</p>
<p align="center">12. State-Machine to implement the SPI DAC Master</p>

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

  <p align="center">
  <img src="https://github.com/user-attachments/assets/db4da775-e2be-43cd-9a6b-0aeb554bfd13" width="600">
</p>
<p align="center">13. SPI DAC master simulation</p>

#### **Results**
| Data Sent | Analog Voltage |
|-----------|---------------|
| 001000000000 | 0.42V |
| 011111111111 | 1.67V |

<p align="center">
  <img src="https://github.com/user-attachments/assets/d62b3c64-ab6d-4be4-8083-54776a6049a3" width="500">
</p>
<p align="center">14. Data vector</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/1594d452-eadd-442b-8674-9d15d6453568" width="500">
</p>
<p align="center">15. Analog voltage for 001000000000</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/55eca8d1-a643-4fd8-b01d-aa084dc4a070" width="500">
</p>
<p align="center">16. Data vector</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/627caea0-8a51-476b-8a6f-fdb6fdeddd90" width="500">
</p>
<p align="center">17. Analog voltage for 011111111111</p>

---

## 3. I2C

### Introduction
**Inter-Integrated Circuit (I2C)** is an 8-bit oriented synchronous serial communication protocol using two wires:
1. **SCL** – Serial Clock.
2. **SDA** – Serial Data.

<p align="center">
  <img src="https://github.com/user-attachments/assets/548d7555-a5ee-4096-86aa-0d2ff31e6159" width="500">
</p>
<p align="center">18. I2C protocol wires</p>

### I2C Data Transfer Process
- The **master** generates a **START** signal.
- The **master** sends a **7-bit address** and a **read/write bit**.
- Communication happens in **data frames**.
- The **master** generates a **STOP** signal at the end.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f437672c-7904-4475-96ea-76ebe7ef33c7" width="300">
</p>
<p align="center">19. I2C start and stop signal</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/a30b0858-58e9-4b32-9df9-b677871d45bb" width="600">
</p>
<p align="center">20. I2C frame for example</p>

### Application
This project implements an **I2C master** to interface with an **LM75 temperature sensor**.

#### Temperature Calculation
The temperature calculation follows these formulas:
- If the sign bit is **positive**:
  $$T(°C) = D(9:0) \times 0.125$$
- If the sign bit is **negative**:
  $$T(°C) = (\text{Two’s complement of } D(9:0)) \times 0.125$$

### VHDL Code Explanation
This VHDL module implements an I2C Master controller to communicate with an LM75 temperature sensor. The module interfaces with the I2C bus using `SCL` (serial clock) and `SDA` (serial data), and it operates at a base system clock of 125 MHz, which is divided down to generate appropriate I2C clock frequencies. Additionally, the temperature data received from the sensor is displayed using LEDs.

#### Functionality Overview
- Clock Generation:
  A 400 kHz clock is derived from the 125 MHz system clock. 
  This clock is further divided to generate a 100 kHz clock, which is the standard I2C communication frequency.

- Finite State Machine (FSM) for I2C Transactions:
  The FSM has multiple states to handle I2C communication from LM75 datasheet timing diagram:

  1. Idle (`st_idle`): The bus remains inactive until data needs to be read.

  2. Start Condition (`st0_star`): Initiates communication by pulling `SDA` low while `SCL` is high.

  3. Send Slave Address (`Write Mode`) (`st1_Address_w`): Sends the LM75's write address (`0x92`).

  4. Acknowledge Handling (`st2_ack1`): Waits for an `ACK` from the LM75.

  5. Send Pointer Register Address (`st3_pointer`): Selects the temperature register (`0x00`).

  6. Acknowledge Handling (`st4_ack2`): Waits for an `ACK` after sending the pointer.

  7. Delay (`st5_delay`): Brief pause before restarting communication.

  8. Restart Condition (`st6_restart`): Generates a repeated START condition for reading data.

  9. Send Slave Address (`Read Mode`) (`st7_Address_r`): Sends the LM75's read address (`0x93`).

  10. Acknowledge Handling (`st8_ack3`): Waits for an `ACK`.

  11. Read Temperature MSB (`st9_read_msb`): Receives the most significant byte (MSB) of temperature data.

  12. Acknowledge (`st10_ack4_Master`): Sends an `ACK` to continue reading.

  13. Read Temperature LSB (`st11_read_lsb`): Receives the least significant byte (LSB) of temperature data.

  14. No Acknowledge (`st12_nack_Master`): Sends a `NACK` to indicate reading is complete.

  15. Stop Condition (`st13_stop`): Releases the I2C bus and ends communication.

- Data Processing and LED Output:
   
  The received MSB and LSB of temperature data are stored in registers.
  The upper bits of the MSB are displayed on LEDs, allowing visual feedback on temperature readings.

- Clock Management:
  
  The 125 MHz input clock is divided down to generate 400 kHz and 100 kHz clocks, ensuring proper timing for I2C communication.
  A counter manages the clock transitions and ensures correct phase alignment.

- I2C Data Handling:
   
  The SDA signal is driven based on the FSM state transitions.
  When reading data, SDA is set to high-impedance ('Z') to allow the LM75 sensor to transmit.
  Bit-wise shifting is used to send the address, pointer, and receive temperature data.

- Summary:
  
  This VHDL module acts as an I2C Master, communicating with the LM75 temperature sensor.
  It follows a structured FSM to handle start, address transmission, data reading, and stop conditions. The received 
  temperature data is stored and displayed using LEDs, making it useful for FPGA-based temperature monitoring applications.

 
<p align="center">
  <img src="https://github.com/user-attachments/assets/5d38be0e-d7ae-498e-93ea-c187676827c7" width="700">
</p>
<p align="center">21. LM75 datasheet timing diagram</p>

#### Additional Details
- The **11-bit result** updates the **11 LED register every 1 second**.
- **SCL frequency**: **100KHz**
- **I2C Address**: `1001001`
- **Pointer**: `00000000`

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ceb3384a-3375-4b44-91d6-fa2bc0a484ea" width="600">
</p>
<p align="center">22. I2C master simulation</p>

#### **Results**
- **Measured Temperature: 31.25°C**

<p align="center">
  <img src="https://github.com/user-attachments/assets/db009f19-6876-4321-a7b6-d707682542e0" width="500">
</p>
<p align="center">23. I2C master result</p>

$$T(°C) = 250 \times 0.125 = 31.25°$$

---

## Summary
This project successfully implements **UART, SPI, and I2C communication protocols on an FPGA** using **VHDL**. The results confirm accurate data transmission and processing.
