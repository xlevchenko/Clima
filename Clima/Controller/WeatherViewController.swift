//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager() //обьект будет отвечать за удержания текущего местоположения нашего телефона
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //подключаем делегат к этому классу
        locationManager.requestWhenInUseAuthorization() //создаем запрос на доступ текущей геопозиции у пользователя
        locationManager.requestLocation() //метод обрабатывает запрос и предоставляет местоположение устройства
        
        
        searchTextField.delegate = self //означает, что его делегат будет равен этому текущему классу
        weatherManager.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //закончил редактирование строки, при нажатии кнопки клавиатура сварачивается
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // при нажатии на кнопку на клавиатуре сворачивается клавиатура и заканчивается редактарование
        print(searchTextField.text!)
        return true
    }
   
    //провеверка на наличее введоного текста в строку ввода. Если срока пустая то в placeholder меняется текст
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here."
            return false
        }
    }
    
    //textField завершено редактирование. Делат сроку ввода пустой
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetcWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    //функция которая обновляет данные на наших view
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async { //не блокирует пользовательский интерфейс во время ожидания ответа на запрос с сети. Делате это в фоновом режиме
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetcWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}


