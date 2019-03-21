import Foundation
import SQLite3

public class Lookup {

	var database: OpaquePointer? = nil

	public init?(databasePath: String?) {
	
		if sqlite3_open(databasePath, &database) != SQLITE_OK {
			print("Error: Failed to open SQLite File")
			return nil
		}
	
	}
	
	public func lookupIndex(passedIndex: Int) -> Token {
	
		var queryPointer: OpaquePointer? = nil
		let selectQuery = "SELECT * FROM Lookup WHERE token = ?;"
		
		if sqlite3_prepare_v2(self.database, selectQuery, -1, &queryPointer, nil) == SQLITE_OK {
		
			sqlite3_bind_int(queryPointer, 1, Int32(passedIndex))

			if sqlite3_step(queryPointer) == SQLITE_ROW {

				if let tokenObject = Token(passedQuery: queryPointer) {
					return tokenObject
				}
			
			}
		
		} else {
			print(String(cString: sqlite3_errmsg(self.database)))
			print("Selection operation failed")
		}
		
		sqlite3_finalize(queryPointer)
		return Token()
		
	}
	
	public func lookupValue(passedValue: String) -> Token {
	
		var queryPointer: OpaquePointer? = nil
		let selectQuery = "SELECT * FROM Lookup WHERE value = ?;"
		
		if sqlite3_prepare_v2(self.database, selectQuery, -1, &queryPointer, nil) == SQLITE_OK {
		
			sqlite3_bind_text(queryPointer, 1, NSString(string: passedValue).utf8String, -1, nil)

			if sqlite3_step(queryPointer) == SQLITE_ROW {

				if let tokenObject = Token(passedQuery: queryPointer) {
					return tokenObject
				}
			
			}
		
		} else {
			print(String(cString: sqlite3_errmsg(self.database)))	
			print("Selection operation failed")
		}
		
		sqlite3_finalize(queryPointer)
		return Token()
		
	}
	
}
