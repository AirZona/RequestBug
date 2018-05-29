import Vapor

struct TestController: RouteCollection {
    
    func boot(router: Router) throws {
        let testRouter = router.grouped("test")
        testRouter.get("create", use: createHandler)
        testRouter.get(Test.parameter, use: getHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<Test> {
        // make a quick pointless call to another server to show the bug, doing nothing with the data
        var headers = HTTPHeaders([])
        headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        
        let url = "https://jsonplaceholder.typicode.com/posts/1"
        
        let client = try req.make(Client.self)
        
        return client.get(url, headers: headers) { req in
            }.flatMap { res in
                
                let test = Test()
                return test.save(on: req)
            }
    }
    
    func getHandler(_ req: Request) throws -> Future<Test> {
        return try req.parameters.next(Test.self)
    }
    
}

