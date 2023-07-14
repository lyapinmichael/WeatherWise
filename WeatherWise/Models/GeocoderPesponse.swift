// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let geocoderResponse = try? JSONDecoder().decode(GeocoderResponse.self, from: jsonData)

import Foundation

// MARK: - GeocoderResponse
class GeocoderResponse: Codable {
    let response: Response

    init(response: Response) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }

    init(geoObjectCollection: GeoObjectCollection) {
        self.geoObjectCollection = geoObjectCollection
    }
}

// MARK: - GeoObjectCollection
class GeoObjectCollection: Codable {
    let metaDataProperty: GeoObjectCollectionMetaDataProperty
    let featureMember: [FeatureMember]

    init(metaDataProperty: GeoObjectCollectionMetaDataProperty, featureMember: [FeatureMember]) {
        self.metaDataProperty = metaDataProperty
        self.featureMember = featureMember
    }
}

// MARK: - FeatureMember
class FeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }

    init(geoObject: GeoObject) {
        self.geoObject = geoObject
    }
}

// MARK: - GeoObject
class GeoObject: Codable {
    let metaDataProperty: GeoObjectMetaDataProperty
    let name, description: String
    let boundedBy: BoundedBy
    let point: Point

    enum CodingKeys: String, CodingKey {
        case metaDataProperty, name, description, boundedBy
        case point = "Point"
    }

    init(metaDataProperty: GeoObjectMetaDataProperty, name: String, description: String, boundedBy: BoundedBy, point: Point) {
        self.metaDataProperty = metaDataProperty
        self.name = name
        self.description = description
        self.boundedBy = boundedBy
        self.point = point
    }
}

// MARK: - BoundedBy
class BoundedBy: Codable {
    let envelope: Envelope

    enum CodingKeys: String, CodingKey {
        case envelope = "Envelope"
    }

    init(envelope: Envelope) {
        self.envelope = envelope
    }
}

// MARK: - Envelope
class Envelope: Codable {
    let lowerCorner, upperCorner: String

    init(lowerCorner: String, upperCorner: String) {
        self.lowerCorner = lowerCorner
        self.upperCorner = upperCorner
    }
}

// MARK: - GeoObjectMetaDataProperty
class GeoObjectMetaDataProperty: Codable {
    let geocoderMetaData: GeocoderMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }

    init(geocoderMetaData: GeocoderMetaData) {
        self.geocoderMetaData = geocoderMetaData
    }
}

// MARK: - GeocoderMetaData
class GeocoderMetaData: Codable {
    let precision: Precision
    let text: String
    let kind: Kind
    let address: Address
    let addressDetails: AddressDetails

    enum CodingKeys: String, CodingKey {
        case precision, text, kind
        case address = "Address"
        case addressDetails = "AddressDetails"
    }

    init(precision: Precision, text: String, kind: Kind, address: Address, addressDetails: AddressDetails) {
        self.precision = precision
        self.text = text
        self.kind = kind
        self.address = address
        self.addressDetails = addressDetails
    }
}

// MARK: - Address
class Address: Codable {
    let countryCode: CountryCode
    let formatted: String
    let components: [Component]

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case formatted
        case components = "Components"
    }

    init(countryCode: CountryCode, formatted: String, components: [Component]) {
        self.countryCode = countryCode
        self.formatted = formatted
        self.components = components
    }
}

// MARK: - Component
class Component: Codable {
    let kind: Kind
    let name: String

    init(kind: Kind, name: String) {
        self.kind = kind
        self.name = name
    }
}

enum Kind: String, Codable {
    case area = "area"
    case country = "country"
    case locality = "locality"
    case province = "province"
}

enum CountryCode: String, Codable {
    case us = "US"
}

// MARK: - AddressDetails
class AddressDetails: Codable {
    let country: Country

    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }

    init(country: Country) {
        self.country = country
    }
}

// MARK: - Country
class Country: Codable {
    let addressLine: String
    let countryNameCode: CountryCode
    let countryName: CountryName
    let administrativeArea: AdministrativeArea

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case countryNameCode = "CountryNameCode"
        case countryName = "CountryName"
        case administrativeArea = "AdministrativeArea"
    }

    init(addressLine: String, countryNameCode: CountryCode, countryName: CountryName, administrativeArea: AdministrativeArea) {
        self.addressLine = addressLine
        self.countryNameCode = countryNameCode
        self.countryName = countryName
        self.administrativeArea = administrativeArea
    }
}

// MARK: - AdministrativeArea
class AdministrativeArea: Codable {
    let administrativeAreaName: AdministrativeAreaName
    let subAdministrativeArea: SubAdministrativeArea

    enum CodingKeys: String, CodingKey {
        case administrativeAreaName = "AdministrativeAreaName"
        case subAdministrativeArea = "SubAdministrativeArea"
    }

    init(administrativeAreaName: AdministrativeAreaName, subAdministrativeArea: SubAdministrativeArea) {
        self.administrativeAreaName = administrativeAreaName
        self.subAdministrativeArea = subAdministrativeArea
    }
}

enum AdministrativeAreaName: String, Codable {
    case штатКалифорния = "штат Калифорния"
}

// MARK: - SubAdministrativeArea
class SubAdministrativeArea: Codable {
    let subAdministrativeAreaName: SubAdministrativeAreaName
    let locality: Locality

    enum CodingKeys: String, CodingKey {
        case subAdministrativeAreaName = "SubAdministrativeAreaName"
        case locality = "Locality"
    }

    init(subAdministrativeAreaName: SubAdministrativeAreaName, locality: Locality) {
        self.subAdministrativeAreaName = subAdministrativeAreaName
        self.locality = locality
    }
}

// MARK: - Locality
class Locality: Codable {
    let localityName: String
    let dependentLocality: DependentLocality?

    enum CodingKeys: String, CodingKey {
        case localityName = "LocalityName"
        case dependentLocality = "DependentLocality"
    }

    init(localityName: String, dependentLocality: DependentLocality?) {
        self.localityName = localityName
        self.dependentLocality = dependentLocality
    }
}

// MARK: - DependentLocality
class DependentLocality: Codable {
    let dependentLocalityName: String

    enum CodingKeys: String, CodingKey {
        case dependentLocalityName = "DependentLocalityName"
    }

    init(dependentLocalityName: String) {
        self.dependentLocalityName = dependentLocalityName
    }
}

enum SubAdministrativeAreaName: String, Codable {
    case каунтиОфСантаКлара = "Каунти-оф-Санта-Клара"
}

enum CountryName: String, Codable {
    case соединённыеШтатыАмерики = "Соединённые Штаты Америки"
}

enum Precision: String, Codable {
    case other = "other"
}

// MARK: - Point
class Point: Codable {
    let pos: String

    init(pos: String) {
        self.pos = pos
    }
}

// MARK: - GeoObjectCollectionMetaDataProperty
class GeoObjectCollectionMetaDataProperty: Codable {
    let geocoderResponseMetaData: GeocoderResponseMetaData

    enum CodingKeys: String, CodingKey {
        case geocoderResponseMetaData = "GeocoderResponseMetaData"
    }

    init(geocoderResponseMetaData: GeocoderResponseMetaData) {
        self.geocoderResponseMetaData = geocoderResponseMetaData
    }
}

// MARK: - GeocoderResponseMetaData
class GeocoderResponseMetaData: Codable {
    let point: Point
    let boundedBy: BoundedBy
    let request, results, found: String

    enum CodingKeys: String, CodingKey {
        case point = "Point"
        case boundedBy, request, results, found
    }

    init(point: Point, boundedBy: BoundedBy, request: String, results: String, found: String) {
        self.point = point
        self.boundedBy = boundedBy
        self.request = request
        self.results = results
        self.found = found
    }
}
