import CSQLite

public class SQLite3 {
  var db: OpaquePointer? = nil

  public init?(path: String) {
    if (sqlite3_open(path, &db) != SQLITE_OK) {
      return nil
    }
  }

  deinit {
    sqlite3_close(db)
  }

  public func version() -> String {
    let version = String(cString: sqlite3_libversion())
    return version
  }

  public func executeQuery(_ query: String) -> [[String]] {
    var result = [[String]]()
    var selectStatement: OpaquePointer? = nil
    if(sqlite3_prepare_v2(db, query, -1, &selectStatement, nil) == SQLITE_OK) {
      let columnCount = Int(sqlite3_column_count(selectStatement))
      let columnNames: [String] = (0..<Int32(columnCount)).map {
        String(cString: sqlite3_column_name(selectStatement, $0))
      }
      result.append(columnNames)
      while(sqlite3_step(selectStatement) == SQLITE_ROW) {
        var row = [String]()
        for i in 0..<columnCount {
        let element = String(cString: sqlite3_column_text(selectStatement,Int32(i)))
        row.append(element) 
        }
        result.append(row)
      }
      sqlite3_finalize(selectStatement)
    }
    return result
  }
}
