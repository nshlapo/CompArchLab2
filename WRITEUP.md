#Lab 2 Write-Up
####Nur Shlapobersky, David Abrahams, Kai Levy

##Input Conditioner

#####Circuit

![](pics/circuit.jpg)

#####Test Bench Output and Waveforms

```
pin conditioned rising falling | Expected
Testing input sync
1   1           1      0       | 1 1 1 0
Testing debouncing
0   1           0      0       | 0 1 0 0
Testing edge detection: falling
0   0           0      1       | 0 0 0 1
Testing edge detection: rising
1   1           1      0       | 1 1 1 0
```

![](pics/waveform.png)

We first check that input synchronization works by changing `noisysignal` at an offset from the clock, and then checking `conditioned` on clock edges. We check debouncing by flickering `noisysignal` on and off and ensuring `conditioned` remains constant. We check that `positiveedge` and `negativeedge` work by forcing `conditioned` to change, and then checking their outputs on the clock cycle where `conditioned` changed. They both go on for one clock cycle, then back off.

#####Question

Question: If the main system clock is running at 50MHz, what is the maximum length input glitch that will be suppressed by this design for a `waittime` of 10? Include the analysis in your report.

Each clock cycle takes 1/(50 * 10^6) seconds, so for `waittime=10`, the maximum length glitch that would be suppressed would be up to (but not including) 10 clock cycles long, so 200 nanoseconds. If the glitch is 200 nanoseconds seconds or longer, it will be seen on 10 clock cycles, and be picked up by our input conditioner.

##Shift Register

#####Test Strategy

First, we test our parallel load, serial out behavior by loading an 8-bit number into the shift register and getting back the most significant bit.

Then, we test our shifting by enabling the peripheral clock edge and loading a bit into the serial data in. We get back parallel data out, which is just like the parallel data that we loaded in the previous test, but shifted over once and with our serial data bit on the end.

Finally, we make sure that we cannot both do parallel load and shift by enabling both. We find that the parallel data out is shifted again, rather than being overwritten by the parallel data in.
