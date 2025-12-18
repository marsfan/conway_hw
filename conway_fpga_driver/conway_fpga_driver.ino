#include <stdint.h>
#define CLK 18
#define DIN 19 // Data into FPGA
#define DOUT 15 // Data out from FPGA
#define RST 26
#define MODE0 10
#define MODE1 9


typedef enum mode_e {
  MODE_HALT = 0b00,
  MODE_LOAD = 0b01,
  MODE_RUN = 0b10,
  MODE_OUT = 0b11,
} mode_e;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while (!Serial); // Loop until serial is ready
  pinMode(CLK, OUTPUT);
  pinMode(DIN, OUTPUT);
  pinMode(DOUT, INPUT);
  pinMode(RST, OUTPUT);
  pinMode(MODE0, OUTPUT);
  pinMode(MODE1, OUTPUT);
  pinMode(5, OUTPUT);
  Serial.print("READY\n");

}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(5, LOW);
  if (Serial.available() >= 16) {
    uint32_t sleep_time = 0;
    uint64_t initial = 0;
    uint32_t cycles = 0;
    Serial.readBytes((uint8_t *)&sleep_time, 4);
    Serial.readBytes((uint8_t *)&initial, 8);
    Serial.readBytes((uint8_t *)&cycles, 4);
    digitalWrite(5, HIGH);
    


    
    reset(sleep_time);
    cycle_clock(sleep_time);
    load_data(initial, sleep_time);

    // Run specified number of times.
    set_mode(MODE_RUN);
    for (int i =0; i < cycles; i++) {
      cycle_clock(sleep_time);
    }


    const uint64_t output = read_data(sleep_time);

    Serial.write((const unsigned char *)&output, 8);

    set_mode(MODE_HALT);

  }

}

void set_mode(const mode_e mode) {
  digitalWrite(MODE0, mode & 0b1);
  digitalWrite(MODE1, (mode >> 1) & 0b1);
}

void cycle_clock(const uint32_t sleep_time) {
  digitalWrite(CLK, HIGH);
  delay(sleep_time);
  digitalWrite(CLK, LOW);
  delay(sleep_time);
}

void reset(const uint32_t sleep_time) {
  digitalWrite(RST, HIGH);
  delay(sleep_time);
  digitalWrite(RST, LOW);
}

void load_data(const uint64_t data, const uint32_t sleep_time) {
  set_mode(MODE_LOAD);

  for(int i = 0; i < 64; i++) {
    uint64_t val = (data >> i) & 0b1;
    digitalWrite(DIN, val);
    cycle_clock(sleep_time);
  }
}

uint64_t read_data(const uint32_t sleep_time) {
  uint64_t result;
  set_mode(MODE_OUT);
  for (int i = 0; i < 64; i++) {
    cycle_clock(sleep_time);
    uint64_t val = digitalRead(DOUT) == HIGH ? 1U : 0U;
    result = result | (val << i);
  }
  return result;
}