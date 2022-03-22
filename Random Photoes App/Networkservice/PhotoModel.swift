//
//  PhotoModel.swift
//  Random Photoes App
//
//  Created by Шамиль Моллачиев on 22.03.2022.
//

import Foundation


struct PhotoModel: Codable {
    let urls: Urls?
}

struct Urls: Codable {
    let raw: String?
    var full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
}
