//Configure these to fit your design...
#define out_STBY 6
#define out_B_PWM 3
#define out_A_PWM 9
#define out_A_IN2 8
#define out_A_IN1 7
#define out_B_IN1 5
#define out_B_IN2 4
#define motor_A 0
#define motor_B 1
#define motor_AB 2


#define mute 2

#define DTMF_D0 12
#define DTMF_D1 13
#define DTMF_D2 10
#define DTMF_D3 11

void setup()
{
  pinMode(out_STBY,OUTPUT);
  pinMode(out_A_PWM,OUTPUT);
  pinMode(out_A_IN1,OUTPUT);
  pinMode(out_A_IN2,OUTPUT);
  pinMode(out_B_PWM,OUTPUT);
  pinMode(out_B_IN1,OUTPUT);
  pinMode(out_B_IN2,OUTPUT);

  pinMode(mute,OUTPUT);
  digitalWrite(mute,HIGH);

  pinMode(DTMF_D0, INPUT);
  pinMode(DTMF_D1, INPUT);
  pinMode(DTMF_D2, INPUT);
  pinMode(DTMF_D3, INPUT);
   
 Serial.begin(9600);
}

void loop()
{
  // default mute if   
  int pressTone = readDTMF();
  switch (pressTone) {
    case 1:
      digitalWrite(mute,LOW);
      Serial.println("forward");
      forward();
      break;
    case 8:
      digitalWrite(mute,LOW);
      Serial.println("left");
      left();
      break;
    case 10:
      digitalWrite(mute,LOW);
      Serial.println("stop");
      break;
    case 9: 
      digitalWrite(mute,LOW);
      Serial.println("right");
      right();
      break;
    case 4: 
      digitalWrite(mute,LOW);
      Serial.println("back");
      backwards();
      break;
    case 0:
      digitalWrite(mute,HIGH);
      break;
    default: 
      digitalWrite(mute,LOW);
      //Serial.println(pressTone);
      break;
  }
  delay(20);
}

int readDTMF() {
  int value = 0;
  if (digitalRead(DTMF_D0) == HIGH) {  value = value + 1; }  
  if (digitalRead(DTMF_D1) == HIGH) {  value = value + 2;}  
  if (digitalRead(DTMF_D2) == HIGH) {  value = value + 4; }  
  if (digitalRead(DTMF_D3) == HIGH) {  value = value + 8; }  
  return value;
}


void backwards() {
  motor_standby(false);
  motor_speed2(motor_A,100);
  motor_speed2(motor_B,100);
  delay(1000);
  motor_standby(true);
}

void forward() {
  motor_standby(false);
  motor_speed2(motor_A,-100);
  motor_speed2(motor_B,-100);
  delay(1000);
  motor_standby(true);
}

void right() {
  motor_standby(false);
  motor_speed2(motor_A,-100);
  motor_speed2(motor_B,100);
  delay(100);
  motor_standby(true);
}

void left() {
  motor_standby(false);
  motor_speed2(motor_A,100);
  motor_speed2(motor_B,-100);
  delay(100);
  motor_standby(true);
}

void test() {
  
    motor_standby(false);
  motor_speed2(motor_A,-100);
  motor_speed2(motor_B,-100);
  delay(2000);
  for (int i=-100; i<100; i++) {
    motor_speed2(motor_A,i);
    motor_speed2(motor_B,i);
    delay(50);
  }
  delay(2000);
  motor_standby(true);
}

void motor_speed2(boolean motor, char speed) { //speed from -100 to 100
  byte PWMvalue=0;
  PWMvalue = map(abs(speed),0,100,50,255); //anything below 50 is very weak
  if (speed > 0)
    motor_speed(motor,0,PWMvalue);
  else if (speed < 0)
    motor_speed(motor,1,PWMvalue);
  else {
    motor_coast(motor);
  }
}
void motor_speed(boolean motor, boolean direction, byte speed) { //speed from 0 to 255
  if (motor == motor_A) {
    if (direction == 0) {
      digitalWrite(out_A_IN1,HIGH);
      digitalWrite(out_A_IN2,LOW);
    } else {
      digitalWrite(out_A_IN1,LOW);
      digitalWrite(out_A_IN2,HIGH);
    }
    analogWrite(out_A_PWM,speed);
  } else {
    if (direction == 0) {
      digitalWrite(out_B_IN1,HIGH);
      digitalWrite(out_B_IN2,LOW);
    } else {
      digitalWrite(out_B_IN1,LOW);
      digitalWrite(out_B_IN2,HIGH);
    }
    analogWrite(out_B_PWM,speed);
  }
}
void motor_standby(boolean state) { //low power mode
  if (state == true)
    digitalWrite(out_STBY,LOW);
  else
    digitalWrite(out_STBY,HIGH);
}
void motor_brake(boolean motor) {
  if (motor == motor_A) {
    digitalWrite(out_A_IN1,HIGH);
    digitalWrite(out_A_IN2,HIGH);
  } else {
    digitalWrite(out_B_IN1,HIGH);
    digitalWrite(out_B_IN2,HIGH);
  }
}
void motor_coast(boolean motor) {
  if (motor == motor_A) {
    digitalWrite(out_A_IN1,LOW);
    digitalWrite(out_A_IN2,LOW);
    digitalWrite(out_A_PWM,HIGH);
  } else {
    digitalWrite(out_B_IN1,LOW);
    digitalWrite(out_B_IN2,LOW);
    digitalWrite(out_B_PWM,HIGH);
  }
} 
