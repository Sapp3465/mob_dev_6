//
//  Bundle.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import Foundation

extension Bundle {
    
    enum DecodeError<T: Decodable>: LocalizedError {

        case missingFile(fileName: String, bundle: Bundle)
        case retrieveData(fileName: String)
        case inappropriateModel(fileName: String, model: T.Type)

        var errorDescription: String? {
            switch self {
            case .missingFile(let fileName, let bundle):
                return "Unable to locate file with name \(fileName) in bundle \(bundle.bundleIdentifier ?? "Default")."
            case .retrieveData(let fileName):
                return "Unable to retrieve date from file with name \(fileName)."
            case .inappropriateModel(let fileName, let model):
                return "Unable to convert data of file wtih name \(fileName) to model ot type \(model)."
            }
        }

    }

    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw DecodeError<T>.missingFile(fileName: file, bundle: self)
        }

        guard let data = try? Data(contentsOf: url) else {
            throw DecodeError<T>.retrieveData(fileName: file)
        }

        let decoder: JSONDecoder =  {
            let decoder = JSONDecoder()

            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy

            return decoder
        } ()

        do {
            return try decoder.decode(T.self, from: data)

        } catch {
            throw DecodeError<T>.inappropriateModel(fileName: file, model: T.self)
        }
    }

}
