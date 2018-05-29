import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let testController = TestController()
    try router.register(collection: testController)
}
