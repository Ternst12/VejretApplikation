

import Foundation
import CoreLocation

protocol VejrManagerDelegate {
    func updaterVejrData(vejret: VejrModel)
    func derErFejl(error: Error)
}


struct VejrManager {
    
    var delegate: VejrManagerDelegate?
    
    let vejrURL = "https://api.openweathermap.org/data/2.5/weather?appid=d8d3f73c048e51703276dca153f93904&units=metric" // Husk https for at undgå sikkerheds error
    
    func fetchVejr(byNavn: String){
        let urlString = "\(vejrURL)&q=\(byNavn)"
        print(urlString)
        self.requestData(with: urlString)
    }
    
    func requestData(with urlstring: String)
    {
        // Create en URL
        if let url = URL(string: urlstring) {
            // Create en URLSession
            let session = URLSession(configuration: .default)
            // Giver Sessionen en opgave
            let opgave = session.dataTask(with: url, completionHandler: handle(data: response: error:)) // henter data fra vejr API -
            
            // Start opgaven
            opgave.resume()
                
            
        }
        
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?)
    {
        if error != nil
        {
            self.delegate?.derErFejl(error: error!)
            return
        }
        
        if let gemData = data {
            if let vejret = parseJSON(vejrdata: gemData) {
                self.delegate?.updaterVejrData(vejret: vejret)
            }
        }
        
    }
    
    // Omformaterer det modtaget JSON objekt til et Swift objekt
    
    func parseJSON(vejrdata: Data) -> VejrModel? {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(VejrData.self, from: vejrdata) //Create et objekt med vejrdata
            print("Henter vejr data for ")
            print(decodedData.name)
            print("hvor temperaturen er ")
            print(decodedData.main.temp)
            print("og vejret kan beskrives som værende")
            print(decodedData.weather[0].description)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            // Create et objekt fra min VejrModel og ligger de decoded værdier i de tilsvarende properties
            
            let vejret = VejrModel(beskrivelseId: id, byNavnet: name, temperatur: temp)
            
            print(vejret.vejrBeskrivelse)
            
            print(vejret.temperaturString)
            return vejret
        } catch {
            self.delegate?.derErFejl(error: error)
            return nil
        }
    }
    
    func fetchVejr(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        let urlString = "\(vejrURL)&lat=\(latitude)&lon=\(longitute)"
        self.requestData(with: urlString)
    }
        
        
}

