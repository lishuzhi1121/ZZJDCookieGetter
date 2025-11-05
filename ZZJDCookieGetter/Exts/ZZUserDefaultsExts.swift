//
//  ZZUserDefaultsExts.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/7.
//

import Cocoa

enum ZZObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into give type"
    
    var errorDescription: String? {
        rawValue
    }
}

protocol ZZObjectSavable {
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object
}

extension UserDefaults: ZZObjectSavable {
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object : Decodable {
        guard let data = data(forKey: forKey) else { throw ZZObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ZZObjectSavableError.unableToDecode
        }
    }
    
    func setObject<Object>(_ object: Object, forKey: String) throws where Object : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            setValue(data, forKey: forKey)
        } catch {
            throw ZZObjectSavableError.unableToEncode
        }
    }

}
