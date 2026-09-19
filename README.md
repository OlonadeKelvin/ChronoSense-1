# ChronoSense
A temperature sensor interface for a 10k NTC thermistor, targeting 0.1 °C accuracy over 0 - 70 °C in IHP SG13CMOS5L. 
The main idea is to convert the sensor's resistance into a frequency, count it, and then send the counts to a microcontroller that computes temperature using 2 identical relaxation
oscillators, one with the NTC, one with a precision reference resistor, running side by side. The ratio of their count cancels errors in their supply, die temp and any other common mode in the analog front end.
