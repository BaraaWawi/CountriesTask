//
//  ImageViewModel.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import UIKit

class ImageViewModel {
    var image: UIImage?

    func loadImage(from url: URL, completion: @escaping () -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil, let data = data else {
                return
            }
            self?.image = UIImage(data: data)
            completion()
        }
        task.resume()
    }
}
