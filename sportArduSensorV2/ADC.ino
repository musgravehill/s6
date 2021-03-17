void ADC_process() {
  /*
    == Exponential Moving Average ==
    output[i] = alpha*input[i] + (1-alpha)*output[i-1]
    0<=alpha<=1
    alpha = 2 /(N+1), where N = average window size
  */
  SYS_acc_main_v = 0.2f * SYS_acc_main_v  + 0.8f * 0.01459830595f * analogRead(SYS_ADC_PIN_acc_main); //k_R-R=3.64   1point == 0.0048828125 V
  SYS_acc_video_v = 0.2f * SYS_acc_video_v + 0.8f * 0.01459830595f * analogRead(SYS_ADC_PIN_acc_video); //k_R-R=3.64   1point == 0.0048828125 V
}

