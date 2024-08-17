//
//  ControllerViewController.swift
//  LunarGapCalendar
//
//  Created by Gonca Seneroğlu on 10.08.2024.
//

import UIKit
import UserNotifications

class ControllerViewController: UIViewController {
    
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    private var voidOfMoonTimes: [LunarSpace] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.labelAssests(radius: 10, borderWidth: 5)
        timeZoneLabel.labelAssests(radius: 10, borderWidth: 5)
        countdownLabel.labelAssests(radius: 10, borderWidth: 5)
        
        styleLabel(titleLabel, font: UIFont(name: "HelveticaNeue-Bold", size: 24)!, textColor: UIColor.white, textAlignment: .center)
        styleLabel(timeZoneLabel, font: UIFont(name: "HelveticaNeue-Medium", size: 18)!, textColor: UIColor.white, textAlignment: .center)
        styleLabel(countdownLabel, font: UIFont(name: "HelveticaNeue-Medium", size: 24) ?? .systemFont(ofSize: 24) , textColor: UIColor.white, textAlignment: .center)
            
        
        setupUI()
        loadVoidOfMoonTimes()
        requestNotificationAuthorization()
        updateStatusLabel()
        scheduleNotifications()
        
        // Belirli aralıklarla otomatik kontrol için zamanlayıcı
        Timer.scheduledTimer(timeInterval: 5.0 , target: self, selector: #selector(updateStatusLabel), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
    }
    
    @objc private func updateCountdown() {
        let now = Date()
        
        for time in voidOfMoonTimes {
            if time.start <= now && now <= time.end {
                let remainingTime = time.end.timeIntervalSince(now)
                titleLabel.text = "Ay Boşlukta"
                timeZoneLabel.text = "\(formatDateTimeZone(time.start)) - \(formatDateTimeZone(time.end))"
                countdownLabel.text = formatTimeInterval(remainingTime)
                return
            }
        }
        
        // Eğer ay boşlukta değilse
        titleLabel.text = "Şu anda ay boşlukta değil."
        countdownLabel.text = ""
    }
    
    private func formatDateTimeZone(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupUI() {
        titleLabel.text = "Şu anda ay boşlukta değil."
    }
    
    private func loadVoidOfMoonTimes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let lunarSpaceTimeZone = [
            ("2024-08-13 12:00", "2024-08-13 13:00"),
            ("2024-08-15 19:52", "2024-08-15 20:51"),
            ("2024-08-17 23:43", "2024-08-18 00:44"),
            ("2024-08-19 21:25", "2024-08-20 01:51"),
            ("2024-08-22 00:53", "2024-08-22 02:01"),
            ("2024-08-23 15:44", "2024-08-24 03:00"),
            ("2024-08-26 04:40", "2024-08-26 06:03"),
            ("2024-08-28 10:13", "2024-08-28 11:47"),
            ("2024-08-30 18:24", "2024-08-30 20:09"),
            ("2024-09-02 03:24", "2024-09-02 06:48"),
            ("2024-09-04 19:06", "2024-09-04 19:11"),
            ("2024-09-07 08:08", "2024-09-07 08:18"),
            ("2024-09-09 20:11", "2024-09-09 20:25"),
            ("2024-09-12 03:20", "2024-09-12 05:37"),
            ("2024-09-14 10:34", "2024-09-14 10:53"),
            ("2024-09-16 08:03", "2024-09-16 12:38"),
            ("2024-09-18 12:02", "2024-09-18 12:23"),
            ("2024-09-20 11:38", "2024-09-20 12:02"),
            ("2024-09-22 13:13", "2024-09-22 13:24"),
            ("2024-09-24 14:58", "2024-09-24 17:50"),
            ("2024-09-27 01:12", "2024-09-27 01:47"),
            ("2024-09-29 06:35", "2024-09-29 12:41"),
            ("2024-10-02 00:38", "2024-10-02 01:19"),
            ("2024-10-04 13:40", "2024-10-04 14:22"),
            ("2024-10-07 01:52", "2024-10-07 02:34"),
            ("2024-10-09 08:53", "2024-10-09 12:38"),
            ("2024-10-11 18:53", "2024-10-11 19:31"),
            ("2024-10-13 17:11", "2024-10-13 22:55"),
            ("2024-10-15 23:00", "2024-10-15 23:34"),
            ("2024-10-17 22:26", "2024-10-17 22:59"),
            ("2024-10-19 22:33", "2024-10-19 23:07"),
            ("2024-10-21 23:59", "2024-10-22 01:49"),
            ("2024-10-24 07:47", "2024-10-24 08:23"),
            ("2024-10-26 11:03", "2024-10-26 18:47"),
            ("2024-10-29 06:54", "2024-10-29 07:29"),
            ("2024-10-31 19:57", "2024-10-31 20:29"),
            ("2024-11-03 07:51", "2024-11-03 08:19"),
            ("2024-11-05 13:23", "2024-11-05 18:17"),
            ("2024-11-08 01:37", "2024-11-08 01:57"),
            ("2024-11-10 03:23", "2024-11-10 06:59"),
            ("2024-11-12 09:13", "2024-11-12 09:25"),
            ("2024-11-14 09:49", "2024-11-14 09:58"),
            ("2024-11-16 10:02", "2024-11-16 10:08"),
            ("2024-11-18 07:08", "2024-11-18 11:49"),
            ("2024-11-20 14:19", "2024-11-20 16:50"),
            ("2024-11-22 16:14", "2024-11-23 02:00"),
            ("2024-11-25 08:34", "2024-11-25 14:19"),
            ("2024-11-27 12:14", "2024-11-28 03:20"),
            ("2024-11-30 09:18", "2024-11-30 14:52"),
            ("2024-12-02 18:47", "2024-12-03 00:08"),
            ("2024-12-05 02:34", "2024-12-05 07:21"),
            ("2024-12-07 03:01", "2024-12-07 12:48"),
            ("2024-12-09 11:44", "2024-12-09 16:37"),
            ("2024-12-11 01:13", "2024-12-11 18:54"),
            ("2024-12-13 15:39", "2024-12-13 20:21"),
            ("2024-12-15 17:31", "2024-12-15 22:21"),
            ("2024-12-17 21:33", "2024-12-18 02:39"),
            ("2024-12-20 08:19", "2024-12-20 10:36"),
            ("2024-12-22 16:27", "2024-12-22 22:07"),
            ("2024-12-24 13:43", "2024-12-25 11:06"),
            ("2024-12-27 17:23", "2024-12-27 22:46"),
            ("2024-12-30 02:34", "2024-12-30 07:37")
        ]
        
        voidOfMoonTimes = lunarSpaceTimeZone.compactMap { (start, end) in
            if let startDate = formatter.date(from: start), let endDate = formatter.date(from: end) {
                return LunarSpace(start: startDate, end: endDate)
            }
            return nil
        }
    }
    
    @objc private func updateStatusLabel() {
        let now = Date()
        var labelText = "Şu anda ay boşlukta değil."
        countdownLabel.isHidden = true
        timeZoneLabel.isHidden = true
        timeImage.isHidden = true
        
        
        for time in voidOfMoonTimes {
            if time.start <= now && now <= time.end {
                labelText = "Ay Boşlukta"
                break
            }
        }
     
     
        
        DispatchQueue.main.async {
            self.titleLabel.text = labelText
        }
    }

    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi.")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
    }
    
    private func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        let now = Date()
        
        for time in voidOfMoonTimes {
            let startInterval = time.start.timeIntervalSinceNow
            let endInterval = time.end.timeIntervalSinceNow
            
            // Zaman aralıklarının pozitif olduğundan emin olun
            if startInterval > 0 {
                let content = UNMutableNotificationContent()
                content.title = "Ay Boşlukta"
                titleLabel.text = content.title
                content.sound = .default
                
                let triggerStart = UNTimeIntervalNotificationTrigger(timeInterval: startInterval, repeats: false)
                let requestStart = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triggerStart)
                notificationCenter.add(requestStart)
            }
            
            if endInterval > 0 {
                let content = UNMutableNotificationContent()
                content.title = "Ay Boşlukta"
                content.sound = .default
                
                let triggerEnd = UNTimeIntervalNotificationTrigger(timeInterval: endInterval, repeats: false)
                let requestEnd = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triggerEnd)
                notificationCenter.add(requestEnd)
            }
        }
    }
    
    func styleLabel(_ label: UILabel, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        
    }
    
    
}


extension UILabel {
    func labelAssests (radius: CGFloat, borderWidth: CGFloat = 0) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
    }
  
}
        
       

