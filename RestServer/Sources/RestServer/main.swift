import Kitura
import Cocoa
import Foundation

let router = Router()

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}


router.get("ClaimService/getAll"){
    request, response, next in
    let pList = ClaimDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    // JSON deserialization on Kitura server
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let T = jDict["title"],
            let D = jDict["date"]{
            let cObj = Claim(UUID: UUID().uuidString, t: T, d: D, s: 0)
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}


Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

