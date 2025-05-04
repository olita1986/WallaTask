//
//  UserDefaultsMock.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 04-05-25.
//

import Foundation

final class UserDefaultsMock: UserDefaults {
    // MARK: - Public Propeties
    
    private(set) var dataCallCount = 0
    private(set) var setCallCount = 0
    private(set) var removeObjectCallCount = 0
    
    //MARK: - Public Methods

    override func data(forKey defaultName: String) -> Data? {
        dataCallCount += 1
        return super.data(forKey: defaultName)
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        setCallCount += 1
        super.set(value, forKey: defaultName)
    }
    
    override func removeObject(forKey defaultName: String) {
        removeObjectCallCount += 1
        super.removeObject(forKey: defaultName)
    }
}
