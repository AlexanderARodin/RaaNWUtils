//
//  NWUtils.swift
//  tst_UDP
//
//  Created by the Dragon on 30.01.2022.
//

import Foundation
import Network

//	//	//	//	//	//	//	//


public func sendData( _ data: Data?, on connection: NWConnection, informInMain: ((_ endpoint: NWEndpoint, _ error: NWError?) -> Void)? = nil) {
	let endpoint = connection.endpoint
	connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
		DispatchQueue.main.async {
			informInMain?(endpoint, NWError)
		}
	})))
}

public func receiveData(on connection: NWConnection, informInMain: @escaping (_ endpoint: NWEndpoint, _ data: Data?, _ error: NWError?) -> Void) {
	let endpoint = connection.endpoint
	connection.receiveMessage { (data, context, isComplete, error) in
		DispatchQueue.main.async {
			informInMain(endpoint, data, error)
		}
	}
}


open class MainCoder {
	static private let encoder = JSONEncoder()
	static private let decoder = JSONDecoder()
	private init(){}
	
	public static func decode<T>(_ type: T.Type, from data: Data) -> T? where T : Decodable {
		try? decoder.decode(T.self, from: data)
	}
	public static func encode<T>(_ value: T) -> Data? where T : Encodable {
		try? encoder.encode(value)
	}
}
