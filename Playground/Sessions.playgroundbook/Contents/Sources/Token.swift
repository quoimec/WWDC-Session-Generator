import Foundation
import SQLite3

public struct Token {

	public var index: Int
	public var value: String
	
	init?(passedQuery: OpaquePointer?) {
	
		guard let safeQuery = passedQuery else {
			print("Empty pointed passed to structure")
			return nil
		}
		
		self.index = Int(sqlite3_column_int(safeQuery, 0))
		self.value = String(cString: sqlite3_column_text(safeQuery, 1)!)
	
	}
	
	init() {
		self.index = 0
		self.value = ""
	}

}
