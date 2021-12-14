//
//  TimerService.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 12/14/21.
//

import UIKit

class TimerService {
    
    var timer: Timer?
    
    var timerValue: Double = 0
    
    var updateTimer: ((Int) -> Void)?

    
    func startTime(time: Int) {
        
        timerValue = Double(time) * 60
        
         timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timer.tolerance = 0.2
             let ceilValue = ceil(self.timerValue / 60)
             self.updateTimer?(Int(ceilValue))
             self.timerValue -= 1

             if self.timerValue <= 0 {
                 self.updateTimer?(0)
                 timer.invalidate()
             }
             
        }
        
    }
    
}
