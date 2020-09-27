//
//  ContentView.swift
//  BetterRest
//
//  Created by phoenix Dai on 2020/9/27.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                Text("When do you want to wake up ?")
                    .font(.headline)
            
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                
                } // 放在一起！
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                        
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
               }
                
               VStack {
                    Text("Daily coffee intake")
                    .font(.headline)
                    
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing: // 尾巴部分的Button
                Button("Calculate") {
                    calculatedBedtime()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculatedBedtime() {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp) // 以小时和分钟返回
       
        let hour = (components.hour ?? 0) * 60 * 60 // 获得小时的秒数
        let minute = (components.hour ?? 0) * 60 // 获得分钟的秒数
        
        do { // 可能会出现问题
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)) // 获得预测数据actualSleep
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter() // 将Date换成"xx:xx AM"
            formatter.timeStyle = .short
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = formatter.string(from: sleepTime)
        } catch { // 错误的时候的响应
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
