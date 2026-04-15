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
This project implements a simple UART receiver and transmitter. The reciver get ASCII code from the tablet via HC-05 Bluetooth module and converts serial data into an 8-bit parallel output using LEDs. The transmitter send the ASCII code of the letter 'A' (01000001) after pushing pysical push-buttom in the developmnt board to tablet via HC-05 Bluetooth module. To ensure separated data and debouncing, the transmit signal goin throe Edge detection with period of 9600Hz. The system using 9600Hz by divede the 125MHz main board clock. The rst signal is synchronous and connect to pysical push-buttom in the developmnt board.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a9e9a793-aca9-4105-8152-6b7ef97d0379" width="400">
</p>
<p align="center">3. HC-05 Module</p>

### **VHDL Code Explanation**
The main module (Main_UART.vhd) is built from 4 submodules. 1. Clock diveder (Clk_div.vhd). 2. UART Transmitter (UART_tx.vhd) 3. UART Reciver (UART_rx.vhd). 4. Edge detection (Edge_detection.vhd). 

The inputs are: `Clk_125MHz`, `rst`, `start_tx_pb` and `rx`.

The outputs are: `tx` and `rx_result_led (7 downto 0)`.

<p align="center">
  <img src="https://github.com/user-attachments/assets/73c7a157-5da6-47f5-a2fd-2c6a836bd308" width="600">
</p>
<p align="center">4. UART System</p>

**1. Main_UART.vhd**

This module represents the top-level integration of the UART system.It connects all submodules required for UART communication, including:
1. Clock divider
2. UART transmitter (TX)
3. UART receiver (RX)
4. Push-button edge detection

The design allows sending data via UART using a push button and receiving UART data and displaying it on LED.

The Main_UART entity acts as the system controller, responsible for: Distributing the clock signal, connecting external inputs/outputs to internal modules
and managing communication between TX and RX blocks.

The design uses a 125 MHz system clock (`Clk_125MHz`) and reset push button input (`rst`). A push button input (`start_tx_pb`) is used to trigger transmission, while the `rx` signal receives serial data from an external UART source. The module outputs serial data through `tx` and displays received 8-bit data on LEDs via `rx_result_led`.

**2. UART_rx.vhd**

This module converts incoming serial UART data into parallel 8-bit data. It detects the start of a reciving data, sample each incoming bit sequentially, and assembles the complete ASCII code (8 bits). The process manage by using FSM. 

The module uses `Clk_9600Hz` as its operating clock and `rst` as synchronous reset signal. The serial data input is `Din`, and the output `Dout[7:0]` stores the received 8-bit data.

The FSM with the states: `start_stop`, `st_0`, `st_1`, `st_2`, `st_3`, `st_4`, `st_5`, `st_6`, and `st_7`. The `start_stop` state waits for the start bit, while each subsequent state captures one bit of data. Two signals, `present_state` and `next_state`, manage the state transitions. The receiver continuously monitors the input line. When the line is high (`1`), the system remains in the idle (`start_stop`) state. When a low signal (`0`) is detected, it indicates the start bit, and the FSM transitions to `st_0`. From there, the module samples one bit per clock cycle. Each state stores the current value of `Din` into the corresponding bit of `Dout`. After all 8 bits are received, the FSM returns to the `start_stop` state to wait for the next transmission. Each state captures one bit, storing data in LSB-first order, meaning the first received bit is placed in `Dout(0)` and the last in `Dout(7)`.

<p align="center">
  <img src="https://github.com/user-attachments/assets/1edd7b93-d960-489d-aabe-ebf783998d87" width="600">
</p>
<p align="center">5. Reciver FSM diagram</p>

**3. UART_tx.vhd**

The module implements a UART transmitter using FSM to send the ASCII code of the letter 'A' (01000001) over the `Data_tx` line according to the UART protocol. 

The module operates using the `Clk_9600Hz` clock and `rst` as synchronous reset signal. The `start_tx` input is used to initiate transmission. The output `Data_tx` is the serial data line that carries the transmitted bits.

The design is based on an FSM with the following states: `idle`, `start_bit`, `st_0`, `st_1`, `st_2`, `st_3`, `st_4`, `st_5`, `st_6`, `st_7`, and `stop_bit`. The `idle` state represents the inactive UART line, while the remaining states correspond to transmitting each part of the UART frame. Two signals, `present_state` and `next_state`, control the state transitions. A constant value 'A' is defined as an 8-bit vector (`x"41"`).The transmitter begins in the `idle` state, where the output line is held high (`1`), which is the default UART idle condition. When the `start_tx` signal is asserted, the FSM transitions to the `start_bit` state, where a low signal (`0`) is transmitted to indicate the start of a frame. The FSM then progresses through states `st_0` to `st_7`, transmitting one bit of the data in each state. The bits are sent in LSB-first order, meaning `A(0)` is transmitted first and `A(7)` last. After all data bits are transmitted, the FSM enters the `stop_bit` state, where the line is set back to high (`1`). Finally, the FSM either returns to the idle state or immediately starts a new transmission if `start_tx` is still asserted.

<p align="center">
  <img src="https://github.com/user-attachments/assets/469cd57b-a9aa-4101-9d54-167cb6478041" width="600">
</p>
<p align="center">6. Transmitter FSM diagram</p>

**4. Edge_detection.vhd**

This module is used to convert a level-based input signal (such as a push button) into a single clock-cycle pulse, ensuring that only one trigger event is generated per rising edge. This is especially important when interfacing mechanical inputs that may remain high for multiple clock cycles.
The module operates using the `Clk_9600Hz` clock. The input `D` is the signal being monitored for transitions, and the output `Q` is a pulse that goes high for one clock cycle when a rising edge is detected on `D`.At every rising edge of the clock, the input signal `D` is first stored in `R0`, and the previous value of `R0` is stored in `R1`. This creates a one-clock-cycle delay between `R0` and `R1`. The output `Q` is generated using combinational logic `Q = (not R1) and R0` that detects when `R0` is high (`1`) and R1 is low (`0`). This condition occurs only when the input signal transitions from 0 to 1, producing a single-cycle pulse. A push button input (`start_tx_pb`) is used to trigger transmission so, in Main_UART `D` get the `start_tx_pb`.

**5. Clk_div.vhd**

The module uses `Clk_125MHz` as the main input clock. The output `Clk_9600Hz` is the generated low-frequency clock used by UART modules.
The design is based on a counter (`counter`) that ranges from 0 to 13020. This value is derived from dividing the input clock frequency (125 MHz) by the desired output frequency (9600 Hz). The counter increments on every rising edge of the input clock and controls the output waveform.
On each rising edge of the 125 MHz clock, the counter increments. For the first half of the count range (from 0 to 6510), the output clock `Clk_9600Hz` is set to low (`0`). For the second half (from 6511 to 13019), the output is set to high (`1`). When the counter reaches 13020, it resets back to zero, and the cycle repeats. This process generates a periodic square wave with a frequency close to 9600 Hz and an approximate 50% duty cycle.

#### **Simulation**

- A test bench is used to verify the UART receiver functionality.

**Main_UART_TB.vhd**

The purpose of this testbench is to validate both UART transmission and reception by providing controlled input signals and monitoring the outputs. It ensures that the integrated system operates correctly under expected timing conditions.The testbench instantiates the Main_UART module as the Device Under Test (DUT) and connects internal signals to simulate real hardware inputs and outputs. Since this is a testbench, it has no external ports and operates entirely within the simulation environment. The testbench defines signals corresponding to the DUT ports, including `Clk_125MHz`, `rst`, `start_tx_pb`, and `rx` as inputs, and `tx` and `rx_result_led` as outputs. These signals are used to drive the DUT and observe its behavior.
A process is used to generate a continuous clock signal. The clock toggles every 4 ns, resulting in a full period of 8 ns, which corresponds to a frequency of 125 MHz. This clock drives the entire system during simulation.
The reset signal (`rst`) is held at logic low (`0`) throughout the simulation, meaning the system is not explicitly reset during operation.
A dedicated process simulates incoming UART data on the `rx` line. The signal starts in the idle state (`1`) and then transitions to (`0`) to represent the start bit. Following this, a sequence of high and low values is applied with precise delays of approximately 104.17 µs, which corresponds to a baud rate of 9600 bits per second. Each delay represents one bit period, allowing the simulation of a full UART frame including start bit, data bits, and stop bit.
Another process simulates a push button press for transmission. The signal `start_tx_pb` is initially low (`0`) and then set high (`1`) for a short duration (200 µs) after a delay. This generates a trigger event that activates the UART transmitter within the DUT.During simulation, the clock process continuously drives the system. The RX stimulus process injects serial data into the receiver, while the push button process triggers the transmitter. The DUT processes these inputs, producing serial output on `tx` and parallel output on `rx_result_led`, which can be observed in waveform viewers.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2fc542ef-df3c-4c84-80fd-7b5a2dbdf4e4" width="800">
</p>
<p align="center">7. TB result waveform </p>

#### **Results**

- **Sending A ('01000001') from tablet via HC-05:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/848db9d0-8111-4c72-b201-c35374aef113" width="500">
</p>
<p align="center">8. Sending A</p>

- **The result:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/423d8d65-cb9d-4715-ab9a-71429d419fec" width="500">
</p>
<p align="center">9. Led result for the letter A</p>

- **Sending z ('01111010') from tablet via HC-05:**

<p align="center">
  <img src="https://github.com/user-attachments/assets/c7989c7e-b85f-4ce3-a4bc-00f4224ff676" width="500">
</p>
<p align="center">10. Sending z</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/847b26b8-00ae-41d9-8ba7-0ee72194c387" width="500">
</p>
<p align="center">11. Led result for the letter z</p>

- **Reciving A ('01000001') from transmitter to tablet via HC-05 after push the start tx push-button:**
  
<p align="center">
  <img src="https://github.com/user-attachments/assets/3c3cc46e-b733-4c99-9130-a9d9777f31cb" width="500">
</p>
<p align="center">12. Reciving the letter A in tablet </p>

#### **Hardware Connection**
The HC-05 module is connected to the **PYNQ development board** using **PMOD GPIO connectors**. The received data is displayed via **8 external LEDs** and the transmited data is displayed in **tablet bluetooth terminal**.

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
