
import Foundation

struct Address {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
    enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipcode
    }
}

extension Address: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(street, forKey: .street)
        try container.encode(suite, forKey: .suite)
        try container.encode(city, forKey: .city)
        try container.encode(zipcode, forKey: .zipcode)
    }
}

extension Address: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        street = try values.decode(String.self, forKey: .street)
        suite = try values.decode(String.self, forKey: .suite)
        city = try values.decode(String.self, forKey: .city)
        zipcode = try values.decode(String.self, forKey: .zipcode)
    }
}
