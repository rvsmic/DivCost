//
//  DivisionStore.swift
//  DivCost
//
//  Created by Michał Rusinek on 24/09/2022.
//

import Foundation
import SwiftUI

class DivisionStore: ObservableObject {
    @Published var divisions: [Division] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("divisions.data")
    }
    
    static func load() async throws -> [Division] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let shops):
                    continuation.resume(returning: shops)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Division], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let decodedDivisions = try JSONDecoder().decode([Division].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedDivisions))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(divisions: [Division]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(divisions: divisions) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let divisionsSaved):
                    continuation.resume(returning: divisionsSaved)
                }
            }
        }
    }
    
    static func save(divisions: [Division], completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(divisions)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(divisions.count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    
}
