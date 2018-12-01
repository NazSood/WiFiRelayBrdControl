#include <SD.h>

#define Relay0 4;
#define Relay1 5;
#define Relay2 6;
#define Relay3 7;


File myFile;
char blueIN, input[150], ip_add[16], dns[16], port[10], ssid[32], pass[50];
String ip_string, dns_string, ssid_string, pass_string, port_string;
int count=0, initial=0, counter=0;
//--Variables--//
char inData[20]; // Allocate some space for the string
char inChar = 0; // Where to store the character read
int index = 0, intData = 0, intData1 = 0; 
boolean started, ended = false;
String Data;

void setup()
{
  Serial.begin(9600);
  // Serial.print("Initializing SD card...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
  pinMode(10, OUTPUT);

  if (!SD.begin(10)) {
    Serial.println("initialization failed!");
    return;
  }
  //Serial.println("initialization done.");  
  // Open the file for reading:
  myFile = SD.open("settings.txt", FILE_READ);
  if (myFile) {
    Serial.println("settings.txt:");
    count = 0;
    // read from the file until there's nothing else in it:
    while (myFile.available()) {
      //Serial.write(myFile.read());
      input[count++] = myFile.read(); 
    }
    Serial.print(input); 
    for (int i=5; i < 201; i++){
      if (input[i] == '='){
        initial = i+1;
        counter++;
      }
      if (input[i] == ','){
        int set = i;
        if (counter == 1){
          for (int a=initial;a < set; a++ ){
            ip_add[a-initial] = input[a];
          }
        }
        if (counter == 2){
          for (int a=initial;a < set; a++ ){
            dns[a-initial] = input[a];
          }
        }
        if (counter == 3){
          for (int a=initial;a < set; a++ ){
            port[a-initial] = input[a];
          }
        }
        if (counter == 4){
          for (int a=initial;a < set; a++ ){
            ssid[a-initial] = input[a];
          }
        }
        if (counter == 5){
          for (int a=initial;a < set; a++ ){
            pass[a-initial] = input[a];
          }
          counter == 0;
        }
        //initial = 0;
        //set = 0;
      }
    }
    Serial.println("IP: ");
    Serial.println(ip_add);
    Serial.println("DNS: ");
    Serial.println(dns);
    Serial.println("Port: ");
    Serial.println(port);
    Serial.println("SSID: ");
    Serial.println(ssid);
    Serial.println("PASS: ");
    Serial.println(pass);
    ip_string = ip_add;
    dns_string = dns;
    port_string = port;
    ssid_string = ssid;
    pass_string = pass;
    Serial.print("$$$");
    delay(500);
    Serial.print("set ip address " + ip_string);
    Serial.print("\r");
    delay(200);
    Serial.print("set ip nm " + dns_string);
    Serial.print("\r");
    delay(200);
    Serial.print("set ip localport " + port_string);
    Serial.print("\r");
    delay(200);
    Serial.print("set wlan ssid " + ssid_string);
    Serial.print("\r");
    delay(500);
    Serial.print("set wlan phrase " + pass_string);
    Serial.print("\r");
    delay(500);
    Serial.print("save\r");
    delay(500);
    Serial.print("exit\r");
    delay(200);
    // close the file:
    myFile.close();
  } 
  else {
    // if the file didn't open, print an error:
    Serial.println("error opening settings.txt");
  }
  Serial.print("exit\r");
  for (int i=4; i < 8; i++){
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }  
}

void loop() {
  while(Serial.available() > 0) // Don't read unless
    // there you know there is data
  {
    inChar = Serial.read(); // Read a character//read the character
    if(inChar =='<') //not sure what to put in if statement to run until end
    {
      started = true;
      ended = false;
      index=0;
    }
    else if(inChar =='>')
    {
      ended = true;
      break;
    } 
    if(started)
    { 
      inData[index] = inChar; // Store it
      index++; // Increment where to write next
      inData[index] = '\0'; // Null terminate the string    
    }
  } 
  if (ended) 
  {
    ended = false;
    Data = inData;//values of acclerometer like "545X" etc enter and stored in Data
    clearing();
    process();
  }
}

void process() {
  Data = Data.replace('<', ' ');
  Data = Data.replace('>', ' ');
  Data = Data.trim();
  char chk = Data.charAt(0);
  if(chk == 'd'){
    Data = Data.replace('d', ' ');
    Data = Data.trim(); 
    char DataChar[4];//char Array to store the char conversion values from DataToInt
    Data.toCharArray(DataChar, sizeof(DataChar));
    intData = atoi(DataChar);
    Serial.println(intData);
    if (intData == 0) {
      digitalWrite(4, HIGH); 
      Serial.print("here");
    }
    if (intData == 1) {
      digitalWrite(5, HIGH); 
    }
    if (intData == 2) {
      digitalWrite(6, HIGH); 
    }
    if (intData == 3) {
      digitalWrite(7, HIGH); 
    }
    if (intData == 5) {
      digitalWrite(4, LOW); 
    }
    if (intData == 6) {
      digitalWrite(5, LOW); 
    }
    if (intData == 7) {
      digitalWrite(6, LOW); 
    }
    if (intData == 8) {
      digitalWrite(7, LOW); 
    }
  }
}


void clearing() {
  //Serial.print("Clearing ALL");
  for(int i=0;i<21;i++)
  {
    inData[i]=0;
  }
  index=0;
  intData = 0;
  Serial.flush();    
}


