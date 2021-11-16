
import Foundation
import UIKit
import CoreLocation


protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
    
struct WeatherManager {
    let watherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f816eaf4350a72f725269ed71d26b7be&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func fetcWeather(cityName: String) {
        let urlString = "\(watherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetcWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(watherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give a sesion a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate = data {
                    if let weather = parseJSON(safeDate) { // создали обьект и присвоили функцию которая получает данные с JSON
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            } //задача которая извлекает содержимое с указанного Url
            
            //4. Start the task
            task.resume() //запускает задачу по извлечения данных из нашего url
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder() // создаем константу и присвоив ей объект, который декодирует экземпляры типа данных из объектов JSON.
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // декодируем наши данные по протоколу Decodable используя WeatherData в котором введены все данные которые надо вытащить из нашего JSON файла
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
           let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            
        }
        return nil
    }
}
