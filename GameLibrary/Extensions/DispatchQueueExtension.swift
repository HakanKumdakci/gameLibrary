//
//  DispatchQueueExtension.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 26.04.2022.
//

import Foundation

protocol DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void)
}


extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
