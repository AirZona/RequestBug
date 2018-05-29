import FluentPostgreSQL
import Vapor

final class Test: Codable {
    
    var id: Int?
    var name: String
    
    init() {
        self.name = "test"
    }
    
}

extension Test: PostgreSQLModel {}
extension Test: Content {}
extension Test: Migration {}

extension Test: Parameter {}


