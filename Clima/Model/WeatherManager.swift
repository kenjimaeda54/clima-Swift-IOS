//
//  WeatherManager.swift
//  Clima
//
//  Created by kenjimaeda on 01/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    func getUrl(cityName:String){
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0f71147fe73f64e20493b89e3e439636&units=metric"
        print(url)
    }
    
}
