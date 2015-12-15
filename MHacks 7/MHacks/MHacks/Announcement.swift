//
//  Announcement.swift
//  MHacks
//
//  Created by Manav Gabhawala on 12/14/15.
//  Copyright © 2015 MPowered. All rights reserved.
//

import Foundation

struct Announcement: Equatable {
	
	let ID: String
	let title: String
	let date: NSDate
	let message: String
	
	static private let todayDateFormatter: NSDateFormatter = {
		let formatter = NSDateFormatter()
		formatter.timeStyle = .ShortStyle
		return formatter;
	}()
	
	static private let otherDayDateFormatter: NSDateFormatter = {
		let formatter = NSDateFormatter()
		formatter.dateStyle = .ShortStyle
		formatter.doesRelativeDateFormatting = true;
		return formatter;
	}()
	
	var localizedDate: String {
		let formatter = NSCalendar.currentCalendar().isDateInToday(date) ? Announcement.todayDateFormatter : Announcement.otherDayDateFormatter
		return formatter.stringFromDate(date)
	}
}

extension Announcement: JSONCreateable {
	
	init?(JSON: [String : Any]) {
		let date = NSDate(timeIntervalSinceReferenceDate: (JSON["date"] as? NSTimeInterval) ?? -1)
		guard let id = JSON["id"] as? String, let title = JSON["title"] as? String, let message = JSON["message"] as? String where NSDate().compare(date) != NSComparisonResult.OrderedAscending
		else
		{
			return nil
		}
		self.ID = id
		self.title = title
		self.date = date
		self.message = message
	}
}

func ==(lhs: Announcement, rhs: Announcement) -> Bool {
	
	return (lhs.ID == rhs.ID &&
		lhs.title == rhs.title &&
		lhs.date == rhs.date &&
		lhs.message == rhs.message)
}
