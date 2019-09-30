void ADC_process() {
  /*
    == Exponential Moving Average ==
    output[i] = alpha*input[i] + (1-alpha)*output[i-1]
    0<=alpha<=1
    alpha = 2 /(N+1), where N = average window size
  */
  SYS_acc_main_v = 0.1f * SYS_acc_main_v  + 0.9f * 0.01362683f * analogRead(SYS_ADC_PIN_acc_main); //13V ---> 4.66V by divider ----> 954 points
  SYS_acc_video_v = 0.1f * SYS_acc_video_v + 0.9f * 0.0048828125f * analogRead(SYS_ADC_PIN_acc_video); //5v ---> 1024 points
}

