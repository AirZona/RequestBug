import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a PostgreSQL database
    let psqlConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "test", database: "Test", password: nil)
    let psqlDatabase = PostgreSQLDatabase(config: psqlConfig)
    
    var dbsConfig = DatabasesConfig()
    dbsConfig.enableLogging(on: .psql)
    
    dbsConfig.add(database: psqlDatabase, as: .psql)
    
    services.register(dbsConfig)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Test.self, database: .psql)
    services.register(migrations)

}
