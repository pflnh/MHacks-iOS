//
//  Announcement.swift
//  MHacks
//
//  Created by Manav Gabhawala on 12/14/15.
//  Copyright © 2015 MHacks. All rights reserved.
//

import Foundation

@objc final class Announcement: NSObject {
	
	struct Category : OptionSetType {
		let rawValue : Int
		static let Emergency = Category(rawValue: 1 << 0)
		static let Logistics = Category(rawValue: 1 << 1)
		static let Food = Category(rawValue: 1 << 2)
		static let Swag = Category(rawValue: 1 << 3)
		static let Sponsor = Category(rawValue: 1 << 4)
		static let Other = Category(rawValue: 1 << 5)
	}
	
	let ID: String
	let title: String
	let message: String
	let date: NSDate
	let category: Category
	let owner: String
	
	init(ID: String, title: String, message: String, date: NSDate, category: Category, owner: String) {
		self.ID = ID
		self.title = title
		self.message = message
		self.date = date
		self.category = category
		self.owner = owner
	}
	
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
		let formatter = NSCalendar.sharedCalendar.isDateInToday(date) ? Announcement.todayDateFormatter : Announcement.otherDayDateFormatter
		return formatter.stringFromDate(date)
	}
	private static let idKey = "id"
	private static let infoKey = "info"
	private static let titleKey = "title"
	private static let dateKey = "broadcast_time"
	private static let categoryKey = "category"
	private static let ownerKey = "owner"
	private static let approvedKey = "approved"
	
	
	@objc convenience init?(serialized: Serialized) {
		guard let id = serialized[Announcement.idKey] as? String, let title = serialized[Announcement.titleKey] as? String, let message = serialized[Announcement.infoKey] as? String, let date = NSDate(JSONValue: serialized[Announcement.dateKey]) where NSDate(timeIntervalSinceNow: 0) > date, let categoryRaw = serialized.intValueForKey(Announcement.categoryKey), let owner = serialized[Announcement.ownerKey] as? String
		else
		{
			return nil
		}
		let approved = serialized.intValueForKey(Announcement.approvedKey) ?? 0
		guard Bool(approved)
		else {
			return nil
		}
		self.init(ID: id, title: title, message: message, date: date, category: Category(rawValue: categoryRaw), owner: owner)
	}
} 

extension Announcement: JSONCreateable, NSCoding {
		
	@objc func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(ID, forKey: Announcement.idKey)
		aCoder.encodeObject(title, forKey: Announcement.titleKey)
		aCoder.encodeObject(message, forKey: Announcement.infoKey)
		aCoder.encodeObject(JSONDateFormatter.stringFromDate(date), forKey: Announcement.dateKey)
	}
	@objc convenience init?(coder aDecoder: NSCoder) {
		self.init(serialized: Serialized(coder: aDecoder))
	}
}

func ==(lhs: Announcement, rhs: Announcement) -> Bool {
	return (lhs.ID == rhs.ID &&
		lhs.title == rhs.title &&
		lhs.date == rhs.date &&
		lhs.message == rhs.message)
}
