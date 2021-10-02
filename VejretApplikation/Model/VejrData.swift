import Foundation

struct VejrData: Decodable { // Data bliver decoded fra JSON
    let name: String // Properties skal navngives i overenstemelse med JSON objektet
    let main: Main // Toplevel i JSON filen for temp data er main. Temp er i et objekt
    let weather: [Weather] // Weather data er i et array
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

