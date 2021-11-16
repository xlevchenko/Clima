import Foundation

struct WeatherData: Codable {
    
    let name: String
    let main: Main //присвоили стурктуру Main
    let weather: [Weather]
    let coord: Coord
}

struct Main: Codable { // Создали структуру в соответствии с протоколом, и дали ей имя как JSON файле
    let temp: Double // Температура 
}

 
struct Weather: Codable {
    let id: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
