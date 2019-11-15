//
//  ViewController.swift
//  5 Minute Timer
//
//  Created by Wim Van Renterghem on 15/11/2019.
//  Copyright © 2019 Bazookas. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

	let notificationCenter = UNUserNotificationCenter.current()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		notificationCenter.getNotificationSettings { settings in
			if settings.authorizationStatus == .notDetermined {
				self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
					if !didAllow {
						print("Please allow notifications")
						return
					}

					self.scheduleNotification(withBody: "You have spent another 5 minutes")
				}
			} else {
				self.scheduleNotification(withBody: "You have spent another 5 minutes")
			}
		}
	}

	func scheduleNotification(withBody body: String) {
		let content = UNMutableNotificationContent()

		content.title = "Another 5 minutes"
		content.body = body
		content.sound = .default

		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5*60, repeats: true)

		let identifier = "Local Notification"
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		notificationCenter.add(request) { error in
			if let error = error {
				print("Error \(error.localizedDescription)")
			}
		}
	}
}

