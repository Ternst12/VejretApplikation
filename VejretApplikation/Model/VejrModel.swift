
import Foundation

struct VejrModel {
    let beskrivelseId: Int
    let byNavnet: String
    let temperatur: Double
    
    // ID matcher en beskrivelse openweatheramp/weather-conditions - Metoden finder et tilsvarende vejr ikon
    
    var vejrBeskrivelse: String { // Computed properti - Skal have et output der returnere en værdi
        switch beskrivelseId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }
    // returner en string med temperatur værdi, der kun har en decimal - computed
    var temperaturString: String {
        return String(format: "%.1f", temperatur)
    }
    
    
    // ID matcher en beskrivelse openweatheramp/weather-conditions - Metoden finder et tilsvarende vejr ikon
    
}
