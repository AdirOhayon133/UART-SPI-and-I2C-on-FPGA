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
  <img src="https://github.com/user-attachments/assets/ad2cf0e8-3720-428b-9099-3e8847bc0827" width="400">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/ebd2d331-6e61-4ef0-b82e-6f6dffe6d679" width="500">
</p>

LSB is the first bit to transfer.

### Application
This project implements a **UART receiver** that connects to a **Bluetooth HC-05 module**. The HC-05 sends ASCII codes from a tablet, and the receiver displays the ASCII code using LEDs.

#### **VHDL Code Explanation**
- **Clock Divider**: Generates a **9600Hz clock** from a **125MHz system clock**.
- **State Machine Implementation**:
  - Detects start bit
  - Reads **8-bit data** from the HC-05
  - Displays the received data on LEDs

<p align="center">
  <img src="https://github.com/user-attachments/assets/88e385ed-1680-414e-9ed5-f9f762050356" width="500">
</p>

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a3800823-1c38-4efd-b657-66761197f01d" width="600">
</p>

#### **Results**
- **ASCII Code for `A` (01000001) sent and received:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/10840b89-54c1-436f-91f8-702ae3a9d15d" width="500">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/423d8d65-cb9d-4715-ab9a-71429d419fec" width="500">
</p>

- **ASCII Code for `z` (01111010) sent and received:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/3242a540-7df3-4344-867f-e7e956dc0051" width="500">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/847b26b8-00ae-41d9-8ba7-0ee72194c387" width="500">
</p>

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

#### **SPI Data Transfer Process**

- The **master** sends a clock signal via **SCK**.
- The **master** lowers **CS** and starts sending data via **MOSI**.
- The **slave** may respond via **MISO**.
- The transmission ends when the **master** raises **CS**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/24aeeedc-730f-4c1e-ba50-305e44e8e472" width="600">
</p>

### Application
This project implements an **SPI master** to control an **MCP4921 12-bit DAC**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0366916e-452f-45a1-9fce-7093503a8b0f" width="500">
</p>

**Voltage Calculation Formula:**

$$V_{out} = \frac{V_{ref} \times D(11:0)}{4096}$$

### VHDL Code Explanation

- **Clock Divider**: Generates a **1MHz SPI clock** from a **125MHz system clock**.
- **State Machine Implementation**:
  - Sends **configuration bits and 12-bit data** to MCP4921.
  - Converts **digital values to analog signals**.
 
  <p align="center">
  <img src="https://github.com/user-attachments/assets/9ab789bb-a63d-4a8f-bd19-1b83664620e0" width="600">
</p>

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

  <p align="center">
  <img src="https://github.com/user-attachments/assets/db4da775-e2be-43cd-9a6b-0aeb554bfd13" width="600">
</p>

#### **Results**
| Data Sent | Analog Voltage |
|-----------|---------------|
| 001000000000 | 0.42V |
| 011111111111 | 1.67V |

<p align="center">
  <img src="https://github.com/user-attachments/assets/d62b3c64-ab6d-4be4-8083-54776a6049a3" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/1594d452-eadd-442b-8674-9d15d6453568" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/55eca8d1-a643-4fd8-b01d-aa084dc4a070" width="500">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/627caea0-8a51-476b-8a6f-fdb6fdeddd90" width="500">
</p>

---

## 3. I2C

### Introduction
**Inter-Integrated Circuit (I2C)** is an 8-bit oriented synchronous serial communication protocol using two wires:
1. **SCL** – Serial Clock.
2. **SDA** – Serial Data.

<p align="center">
  <img src="https://github.com/user-attachments/assets/548d7555-a5ee-4096-86aa-0d2ff31e6159" width="500">
</p>

### I2C Data Transfer Process
- The **master** generates a **START** signal.
- The **master** sends a **7-bit address** and a **read/write bit**.
- Communication happens in **data frames**.
- The **master** generates a **STOP** signal at the end.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f437672c-7904-4475-96ea-76ebe7ef33c7" width="300">
</p>


<p align="center">
  <img src="https://github.com/user-attachments/assets/a30b0858-58e9-4b32-9df9-b677871d45bb" width="600">
</p>

### Application
This project implements an **I2C master** to interface with an **LM75 temperature sensor**.

### Temperature Calculation
The temperature calculation follows these formulas:
- If the sign bit is **positive**:
  $$T(°C) = D(9:0) \times 0.125$$
- If the sign bit is **negative**:
  $$T(°C) = (\text{Two’s complement of } D(9:0)) \times 0.125$$

  ### VHDL Code Explanation

The **State Machine** is used to implement the system.

- **read_data Process**: Creates a `read_data` signal that rises from low to high every **1 second** to update the temperature using a **clock divider** from the **125MHz system clock**.
- **clk400KHz Process**: Generates a **400KHz clock** from the **125MHz system clock** using a **clock divider**.
- **clk_100KHz Process**: Generates a **100KHz clock** from the **125MHz system clock** for the **SCL signal** and system clock. The **Data Clock Signal (DCL)** is shifted **left by ¼ period** from SCL using a **clock divider**.
- **Present_state_and_next_state Process**: Sets the next state in the **State Machine**:
  - On **DCL rising edge**, if the **reset button** is pressed, the system enters the `st_idle` state.
  - If the reset button is **not** pressed and `data_index = num_of_ret - 1`, the system transitions to the **next state**.
- **Registers_in Process**: Sets the **MSB and LSB** signals from the received LM75 data when:
  - Present state = `st9_read_msb`
  - Present state = `st11_read_lsb`
  - On **DCL falling edge**
- **p3 Process**: Implements the **I2C Master** using the **State Machine**:
  - If `rd_data = 0`, the system enters the `st_idle` state.
  - If `rd_data = 1`, the **State Machine starts running** according to the **LM75 datasheet timing diagram**.
 
<p align="center">
  <img src="https://github.com/user-attachments/assets/5d38be0e-d7ae-498e-93ea-c187676827c7" width="700">
</p>

### Additional Details
- The **11-bit result** updates the **11 LED register every 1 second**.
- **SCL frequency**: **100KHz**
- **I2C Address**: `1001001`
- **Pointer**: `00000000`

#### **Simulation**
- A test bench is used to verify the UART receiver functionality.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ceb3384a-3375-4b44-91d6-fa2bc0a484ea" width="600">
</p>

#### **Results**
- **Measured Temperature: 31.25°C**

<p align="center">
  <img src="https://github.com/user-attachments/assets/db009f19-6876-4321-a7b6-d707682542e0" width="500">
</p>


$$T(°C) = 250 \times 0.125 = 31.25°$$

---

## Summary
This project successfully implements **UART, SPI, and I2C communication protocols on an FPGA** using **VHDL**. The results confirm accurate data transmission and processing.
